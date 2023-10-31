# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  # 言及
  has_many :active_mentions, class_name: 'Mention', foreign_key: :mentioning_report_id, dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report

  # 被言及
  has_many :passive_mentions, class_name: 'Mention', foreign_key: :mentioned_report_id, dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_mentions
    self.active_mentions.destroy_all if self.active_mentions.any?
    report_ids = extract_report_ids(self.content)
    report_ids.each do |report_id|
      Mention.create!(mentioning_report_id: self.id, mentioned_report_id: report_id)
    end
  end

  def extract_report_ids(text, regexp = %r{http://localhost:3000/reports/(\d+)})
    text.scan(regexp).flatten.uniq
  end
end
