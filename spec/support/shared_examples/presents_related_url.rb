RSpec.shared_examples "presents related_url" do
  it "provides related_url" do
    expect(subject).to respond_to(:related_url)
  end
  it "provides catalog_url" do
    expect(subject).to respond_to(:catalog_url)
  end
end
