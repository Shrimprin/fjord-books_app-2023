# frozen_string_literal: true

require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  setup do
    @book = books(:alice_book)
    @report = reports(:alice_report)
    visit root_url

    fill_in User.human_attribute_name(:email), with: 'alice@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('devise.shared.links.sign_in')

    assert_css 'h1', text: Book.model_name.human # CapybaraにTurbolinks処理完了を待たせる
  end

  test 'visiting the index' do
    # 本へのコメント
    visit book_url(@book)
    assert_selector '.comments-container strong', text: "#{Comment.model_name.human}:"

    # 日報へのコメント
    visit report_url(@report)
    assert_selector '.comments-container strong', text: "#{Comment.model_name.human}:"
  end

  test 'should create comment' do
    # 本へのコメント
    visit book_url(@book)
    # fill_in Comment.human_attribute_name(:content), with: '素晴らしいですね！'
    fill_in 'comment[content]', with: '素晴らしいですね！' # human_attributeだとElementNotFoundとなる
    click_on I18n.t('shared.comments.create')

    assert_text I18n.t('controllers.common.notice_create', name:Comment.model_name.human)
    assert_text '素晴らしいですね！'

    # 日報へのコメント
    visit book_url(@book)
    # fill_in Comment.human_attribute_name(:content), with: '素晴らしいですね！'
    fill_in 'comment[content]', with: '素晴らしいですね！' # human_attributeだとElementNotFoundとなる
    click_on I18n.t('shared.comments.create')

    assert_text I18n.t('controllers.common.notice_create', name:Comment.model_name.human)
    assert_text '素晴らしいですね！'
  end

  test 'should destroy Report' do
    # 本へのコメント
    visit book_url(@book)
    assert_text '私も読みました！'
    accept_confirm do
      click_on I18n.t('shared.comments.delete'), match: :first
    end
    assert_text I18n.t('controllers.common.notice_destroy', name: Comment.model_name.human)
    assert_no_text '私も読みました！'
    assert_text I18n.t('shared.comments.no_comments')

    # 日報へのコメント
    visit report_url(@report)
    assert_text '目から鱗です！'
    accept_confirm do
      click_on I18n.t('shared.comments.delete'), match: :first
    end
    assert_text I18n.t('controllers.common.notice_destroy', name: Comment.model_name.human)
    assert_no_text '目から鱗です！'
    assert_text I18n.t('shared.comments.no_comments')
  end
end
