# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable? should return true when user is author' do
    alice_report = reports(:alice_report)
    assert alice_report.editable?(users(:alice))
  end

  test '#editable? should return true when user is not author' do
    alice_report = reports(:alice_report)
    assert_not alice_report.editable?(users(:bob))
  end

  test '#created_on should return the date of creation' do
    alice_report = reports(:alice_report)
    assert_equal Date.parse('2021-11-30'), alice_report.created_on
  end

  test '#save_mentions' do
    ### 事前準備
    bob_report = reports(:bob_report)
    carol_report = reports(:carol_report)
    dave_report = reports(:dave_report)
    alice = users(:alice)

    ### 日報作成時のテスト
    # 内容に含まれる日報が言及に追加されるか
    # 同じ日報を複数言及している際、言及が重複しないか
    alice_report = alice.reports.create!(
      title: '日報作成時のテスト',
      content: <<~TEXT
        bobの日報を言及します。
        http://localhost:3000/reports/#{bob_report.id}
        carolの日報を言及します。
        http://localhost:3000/reports/#{carol_report.id}
        carolの日報を重複して言及します。
        http://localhost:3000/reports/#{carol_report.id}
      TEXT
    )

    assert_equal [bob_report, carol_report], alice_report.mentioning_reports
    assert_equal [alice_report], bob_report.mentioned_reports
    assert_equal [alice_report], carol_report.mentioned_reports

    ### 日報更新時のテスト
    # 更新の前も後も内容にURLが含まれる日報は言及されたままか
    # 内容から日報のURLを削除したら言及も削除されるか
    # 内容に追記したURLが言及に追加されるか
    # 自身のURLを内容に書いても言及されないか
    alice_report.update!(
      title: '日報更新時のテスト',
      content: <<~TEXT
        bobの日報はそのまま言及します。
        http://localhost:3000/reports/#{bob_report.id}
        carolの日報の代わりにdaveの日報を言及します。
        http://localhost:3000/reports/#{dave_report.id}
        この日報自身を言及します。
        http://localhost:3000/reports/#{alice_report.id}
      TEXT
    )

    [alice_report, bob_report, carol_report].each(&:reload)
    assert_equal [bob_report, dave_report], alice_report.mentioning_reports
    assert_equal [alice_report], bob_report.mentioned_reports
    assert_equal [alice_report], dave_report.mentioned_reports
    assert_equal [], carol_report.mentioned_reports
    assert_equal [], alice_report.mentioned_reports

    ### 日報削除時のテスト
    # 言及も削除されるか
    alice_report.destroy!
    [bob_report, dave_report].each(&:reload)
    assert_equal [], bob_report.mentioned_reports
    assert_equal [], dave_report.mentioned_reports
  end
end
