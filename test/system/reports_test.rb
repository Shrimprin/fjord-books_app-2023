# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    visit root_url

    fill_in User.human_attribute_name(:email), with: 'alice@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('devise.shared.links.sign_in')

    assert_css 'h1', text: Book.model_name.human # CapybaraにTurbolinks処理完了を待たせる
  end

  test 'visiting the index' do
    visit reports_url

    assert_selector 'h1', text: I18n.t('views.common.title_index', name: Report.model_name.human)
  end

  test 'should create report' do
    visit reports_url
    click_on I18n.t('views.common.new', name: Report.model_name.human)

    fill_in Report.human_attribute_name(:content), with: '今日は晴れだった！'
    fill_in Report.human_attribute_name(:title), with: '今日の天気'
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('controllers.common.notice_create', name: Report.model_name.human)
    assert_text '今日の天気'
    assert_text '今日は晴れだった'
    assert_text 'Alice'
    click_on I18n.t('views.common.back', name: Report.model_name.human)
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on I18n.t('views.common.edit', name: Report.model_name.human), match: :first

    fill_in Report.human_attribute_name(:content), with: '今日は晴れのち曇り...'
    fill_in Report.human_attribute_name(:title), with: '今日の天気（更新）'
    click_on I18n.t('helpers.submit.update')

    assert_text I18n.t('controllers.common.notice_update', name: Report.model_name.human)
    assert_text '今日の天気（更新）'
    assert_text '今日は晴れのち曇り...'
    click_on I18n.t('views.common.back', name: Report.model_name.human)
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on I18n.t('views.common.destroy', name: Report.model_name.human), match: :first

    assert_text I18n.t('controllers.common.notice_destroy', name: Report.model_name.human)
    assert_selector 'h1', text: I18n.t('views.common.title_index', name: Report.model_name.human)
  end
end
