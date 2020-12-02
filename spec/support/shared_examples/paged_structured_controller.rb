RSpec.shared_examples "paged_structure persister" \
do |resource_symbol, presenter_factory, resource_controller|

  describe "when logged in" do

    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }
    let(:user) { FactoryBot.create(:user) }

    before { sign_in user }
    describe "#structure", :clean do

      let(:solr) { ActiveFedora.solr.conn }
      let(:resource) do
        r = FactoryBot.create(resource_symbol)
        allow(r).to receive(:id).and_return("1")
        allow(r.list_source).to receive(:id).and_return("3")
        r
      end
      let(:file_set) { FactoryBot.build(:file_set, id: "2") }

      before do
        allow(resource.class).to receive(:find).and_return(resource)
        allow_any_instance_of(resource_controller).to receive(:authorize!).and_return(true)
        resource.ordered_members << file_set
        solr.add file_set.to_solr.merge(ordered_by_ssim: [resource.id])
        solr.add resource.to_solr
        solr.add resource.list_source.to_solr
        solr.commit
      end

      it "sets @members" do
        obj = instance_double("logical order object")
        allow_any_instance_of(presenter_factory) \
        .to receive(:logical_order_object).and_return(obj)
        get :structure, params: {id: resource.id}

        expect(assigns(:members).map(&:id)).to eq ["2"]
      end
      it "sets @logical_order" do
        obj = instance_double("logical order object")
        allow_any_instance_of(presenter_factory) \
        .to receive(:logical_order_object).and_return(obj)
        get :structure, params: {id: resource.id}

        expect(assigns(:logical_order)).to eq obj
      end
    end

    describe "#save_structure", :clean, :perform_enqueued do

      let(:resource) { FactoryBot.create(resource_symbol, user: user) }
      let(:file_set) { FactoryBot.create(:file_set, user: user) }
      let(:user) { FactoryBot.create(:admin) }
      let(:nodes) do
        [
            {
                'label': 'Chapter 1',
                'nodes': [
                    {
                        'proxy': file_set.id
                    }
                ]
            }
        ]
      end

      before do
        sign_in user
        resource.ordered_members << file_set
        resource.save
      end

      it "persists order" do
        post :save_structure, params: {nodes: nodes, id: resource.id, label: "TOP!"}

        expect(response.status).to eq 200
        expect(resource.reload.logical_order.order) \
        .to eq({ 'label': 'TOP!', 'nodes': nodes }.with_indifferent_access)
      end

      it 'returns Locked status for a locked resource' do
        allow_any_instance_of(resource.class).to receive(:lock?).and_return(true)
        post :save_structure, params: {nodes: nodes, id: resource.id, label: 'TOP!'}
        expect(response.status).to eq 423
      end
    end

    describe '#manifest', :clean do
      let(:resource) { FactoryBot.create(resource_symbol) }
      let(:fs1) { FactoryBot.create(:file_set, user: user) }
      let(:fs2) { FactoryBot.create(:file_set, user: user) }

      before do
        allow_any_instance_of(presenter_factory) \
          .to receive(:logical_order).and_return(logical_order)
        allow_any_instance_of(presenter_factory) \
          .to receive(:member_presenters).and_return(member_presenters)
      end

      context 'without structured content' do
        let(:logical_order) { {} }
        let(:member_presenters) { [] }

        it 'returns a minimal structure section' do
          get :manifest, params: { id: resource.id }
          structures = JSON.parse(response.body).dig('structures')

          expect(structures.first['label']).to be_blank
          expect(structures.first['ranges']).to be_blank
          expect(structures.first['canvases']).to be_blank
        end
      end

      context 'with structured content' do
        let(:member_presenters) do
          [fs1, fs2].map do |fs|
            solr_doc = SolrDocument.new(fs.to_solr)
            ability = Ability.new(user)
            Hyrax::FileSetPresenter.new(solr_doc, ability)
          end
        end
        let(:logical_order) do
          { label: 'Logical',
            nodes: [{ label: 'Section 1',
                      nodes: [{ label: 'Subsection A',
                                nodes: [{ proxy: fs1.id }] }] },
                    { label: 'Section 2',
                      nodes: [{ proxy: fs2.id }] }] }
        end

        it 'returns a content-bearing structure section' do
          get :manifest, params: { id: resource.id }
          structures = JSON.parse(response.body).dig('structures')

          expect(structures[0]['label']).to eq 'Logical'
          expect(structures[0]['ranges']).to match [structures[1]['@id'],
                                                    structures[3]['@id']]
          expect(structures[0]['canvases']).to be_empty

          expect(structures[1]['label']).to eq 'Section 1'
          expect(structures[1]['ranges']).to match [structures[2]['@id']]
          expect(structures[1]['canvases']).to be_empty

          expect(structures[2]['label']).to eq 'Subsection A'
          expect(structures[2]['ranges']).to be_empty
          expect(structures[2]['canvases'].first).to match fs1.id

          expect(structures[3]['label']).to eq 'Section 2'
          expect(structures[3]['ranges']).to be_empty
          expect(structures[3]['canvases'].first).to match fs2.id
        end
      end
    end
  end
end
