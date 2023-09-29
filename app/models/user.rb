# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :icon do |attachable|
    attachable.variant :display, resize_to_limit: [100, 100]
  end

  validates :icon,
            content_type: { in: %w[image/jpeg image/gif image/png],
                            message: I18n.t('activerecord.errors.messages.icon.content_type', type: 'jpeg, gif, png') },
            size: { less_than: 5.megabytes,
                    message: I18n.t('activerecord.errors.messages.icon.size', limit: '5MB') }
end
