require 'rails_helper'

RSpec.describe ESSI::Actors::PerformLaterActor do
  before :all do
    RSpec::Mocks.with_temporary_scope do
      @work = FactoryBot.create(:paged_resource)
      @user = FactoryBot.create(:user)
      @ability = ::Ability.new(@user)
    end
  end

  let(:env) { Hyrax::Actors::Environment.new(@work, @ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:attributes) { {title: 'Procrastination Test'} }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  describe "#create" do
    context 'when called directly' do
      it 'enqueues a PerformLaterActorJob' do
        expect { middleware.create(env) }.to have_enqueued_job(PerformLaterActorJob).with {
            |action, curation_concern, ability_user, attributes_for_actor|
          expect(action).to eq 'create'
          expect(curation_concern).to eq 'PagedResource'
          expect(ability_user).to eq @user
          expect(attributes_for_actor).to match( 'title': 'Procrastination Test', 'in_perform_later_actor_job': true )
        }
      end
    end

    context 'when called from PerformLaterActorJob' do
      let(:attributes) { {title: 'Procrastination Test', 'in_perform_later_actor_job': true} }

      it 'continues down the Actor stack' do
        expect(terminator).to receive(:create).with(
            having_attributes(:attributes => hash_excluding('in_perform_later_actor_job'))
        )
        expect { middleware.create(env) }.not_to have_enqueued_job(PerformLaterActorJob)
      end
    end
  end

  describe "#update" do
    context 'by default' do
      it 'enqueues a PerformLaterActorJob' do
        expect { middleware.update(env) }.to have_enqueued_job(PerformLaterActorJob).with {
            |action, curation_concern, ability_user, attributes_for_actor|
          expect(action).to eq 'update'
          expect(curation_concern).to eq(@work).and(be_a PagedResource)
          expect(ability_user).to eq @user
          expect(attributes_for_actor).to match( 'title': 'Procrastination Test', 'in_perform_later_actor_job': true )
        }
      end
    end

    context 'when called from PerformLaterActorJob' do
      let(:attributes) { {title: 'Procrastination Test', 'in_perform_later_actor_job': true} }

      it 'continues down the Actor stack' do
        expect(terminator).to receive(:update).with(
            having_attributes(:attributes => hash_excluding('in_perform_later_actor_job'))
        )
        expect { middleware.update(env) }.not_to have_enqueued_job(PerformLaterActorJob)
      end
    end

    context 'when called from IIIF Print' do
      let(:attributes) { { work_members_attributes: 'foo' } }

      it 'continues down the Actor stack' do
        expect(terminator).to receive(:update).with(
            having_attributes(:attributes => attributes )
        )
        expect { middleware.update(env) }.not_to have_enqueued_job(PerformLaterActorJob)
      end
    end
  end

  describe "#destroy" do
    context 'by default' do
      it 'enqueues a PerformLaterActorJob' do
        expect { middleware.destroy(env) }.to have_enqueued_job(PerformLaterActorJob).with {
            |action, curation_concern, ability_user, attributes_for_actor|
          expect(action).to eq 'destroy'
          expect(curation_concern).to eq(@work).and(be_a PagedResource)
          expect(ability_user).to eq @user
          expect(attributes_for_actor).to match( 'title': 'Procrastination Test', 'in_perform_later_actor_job': true )
        }
      end
    end

    context 'when called from PerformLaterActorJob' do
      let(:attributes) { {title: 'Procrastination Test', 'in_perform_later_actor_job': true} }

      it 'continues down the Actor stack' do
        expect(terminator).to receive(:destroy).with(
            having_attributes(:attributes => hash_excluding('in_perform_later_actor_job'))
        )
        expect { middleware.destroy(env) }.not_to have_enqueued_job(PerformLaterActorJob)
      end
    end
  end
end
