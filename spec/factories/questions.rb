FactoryBot.define do
  sequence :title do |n|
    "Question Title#{n}"
  end

  sequence :body do |n|
    "Question Body#{n}"
  end

  factory :question do
    title
    body
    user
    best_answer { nil }
    award { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_best_answer do
      best_answer factory: :answer
    end

    trait :with_award do
      award factory: :award
    end

    factory :question_with_file do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join("spec", "files", "star.jpg")), filename: 'star.jpg',
                              content_type: 'image/jpeg')
      end
    end

    factory :question_with_links do
      transient do
        links_count { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:link, evaluator.links_count, linkable: question)
      end
    end

    factory :question_with_comments do
      transient do
        comments_count { 3 }
      end

      after(:create) do |_comment, evaluator|
        create_list(:comment, evaluator.comments_count, commentable: question)
      end
    end

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
