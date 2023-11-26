# frozen_string_literal: true

require 'application_system_test_case'

class ReportMentionsTest < ApplicationSystemTestCase
  setup do
    @alice_report = reports(:alice_mention_report)
    @bob_report = reports(:bob_mention_report)
    @carol_report = reports(:carol_mention_report)
    visit root_url

    fill_in User.human_attribute_name(:email), with: 'alice@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('devise.shared.links.sign_in')

    assert_css 'h1', text: Book.model_name.human # CapybaraにTurbolinks処理完了を待たせる
  end

  test 'visiting the index' do
    visit report_url(@alice_report)

    assert_text 'ボブの言及レポート'
    assert_text 'キャロルの言及レポート'
  end

  test 'should create Mention' do
    visit reports_url
    click_on I18n.t('views.common.new', name: Report.model_name.human)

    fill_in Report.human_attribute_name(:title), with: 'アリスが言及します'
    fill_in Report.human_attribute_name(:content), with: "carolの日報を言及します。http://localhost:3000/reports/#{@carol_report.id}"
    click_on I18n.t('helpers.submit.create')

    assert_selector "a[href='http://localhost:3000/reports/#{@carol_report.id}']", text: "http://localhost:3000/reports/#{@carol_report.id}"
    visit report_url(@carol_report)
    assert_text 'アリスが言及します'
  end

  test 'should update Mention' do
    visit report_url(@bob_report)
    assert_text 'アリスの言及レポート'

    visit report_url(@alice_report)
    click_on I18n.t('views.common.edit', name: Report.model_name.human), match: :first

    fill_in Report.human_attribute_name(:content), with: "carolの日報を言及します。http://localhost:3000/reports/#{@carol_report.id}"
    click_on I18n.t('helpers.submit.update')

    assert_selector "a[href='http://localhost:3000/reports/#{@carol_report.id}']", text: "http://localhost:3000/reports/#{@carol_report.id}"
    visit report_url(@carol_report)
    assert_text 'アリスの言及レポート'
    visit report_url(@bob_report)
    assert_no_text 'アリスの言及レポート'
  end

  test 'should destroy Mnetion' do
    visit report_url(@bob_report)
    assert_text 'アリスの言及レポート'

    visit report_url(@alice_report)
    click_on I18n.t('views.common.destroy', name: Report.model_name.human), match: :first

    assert_text I18n.t('controllers.common.notice_destroy', name: Report.model_name.human)
    visit report_url(@bob_report)
    assert_no_text 'アリスの言及レポート'
  end
end
