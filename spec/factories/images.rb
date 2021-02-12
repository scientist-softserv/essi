FactoryBot.define do
  factory :image do
    title { ["Test title"] }
    rights_statement { ["http://rightsstatements.org/vocab/NKC/1.0/"] }
    description { ["900 years of time and space, and I’ve never been slapped" \
    " by someone’s mother."] }
    visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    state { "complete" }

    transient do
      user { FactoryBot.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :image_with_one_image do
      after(:build) do |work, evaluator|
        work.ordered_members << file_set = FactoryBot.create(:file_set, user: evaluator.user, content: File.open(RSpec.configuration.fixture_path + '/world.png'),
                                       title: ['A Contained FileSet'], label: 'world.png')
        work.representative = file_set if work.representative_id.blank?
        work.thumbnail = file_set if work.thumbnail_id.blank?
        work.save

      end
    end
  end
end
