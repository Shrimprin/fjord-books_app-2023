# frozen_string_literal: true

module ApplicationHelper
  # localeに応じて複数形の表記を変える
  # - 日本語の場合 => 本
  # - 英語の場合 => books
  def i18n_pluralize(word)
    I18n.locale == :ja ? word : word.pluralize
  end

  # localeに応じてエラー件数の表記を変える
  # - 日本語の場合 => 3件のエラー
  # - 英語の場合 => 3 errors
  def i18n_error_count(count)
    I18n.locale == :ja ? "#{count}件の#{t('views.common.error')}" : pluralize(count, t('views.common.error'))
  end

  def format_content(content)
    safe_join(content.split("\n"), tag.br)
  end

  def auto_link_urls(text)
    uri_reg = URI.regexp(%w[http https])
    linked_text =
      text.gsub(uri_reg) do |url|
        "<a href=#{url}>#{url}</a>"
      end
    # <a>タグとhref属性以外のHTMLタグや属性はエスケープする
    sanitize(linked_text, tags: %w[a], attributes: %w[href])
  end
end
