# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:alice_book)
    visit root_url

    fill_in User.human_attribute_name(:email), with: 'alice@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('devise.shared.links.sign_in')

    assert_css 'h1', text: Book.model_name.human # CapybaraにTurbolinks処理完了を待たせる
  end

  test 'visiting the index' do
    visit books_url

    assert_selector 'h1', text: I18n.t('views.common.title_index', name: Book.model_name.human)
  end

  test 'should create book' do
    visit books_url
    click_on I18n.t('views.common.new', name: Book.model_name.human)

    fill_in Book.human_attribute_name(:title), with: '黒猫の一日'
    fill_in Book.human_attribute_name(:memo), with: '猫かわいい'
    fill_in Book.human_attribute_name(:author), with: 'Kuroneko'
    attach_file Book.human_attribute_name(:picture), Rails.root.join('test/fixtures/files/avatar.jpg')

    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('controllers.common.notice_create', name: Book.model_name.human)
    assert_text '黒猫の一日'
    assert_text '猫かわいい'
    assert_text 'Kuroneko'
    book = Book.last
    assert_selector "img[src*='/uploads/book/picture/#{book.id}/avatar.jpg']"
    click_on I18n.t('views.common.back', name: Book.model_name.human)
  end

  test 'should update Book' do
    visit book_url(@book)
    click_on I18n.t('views.common.edit', name: Book.model_name.human), match: :first

    fill_in Book.human_attribute_name(:title), with: '黒猫の一日(改訂版)'
    fill_in Book.human_attribute_name(:memo), with: '相変わらず猫かわいい'
    fill_in Book.human_attribute_name(:author), with: 'Kuro Nekosuke'
    attach_file Book.human_attribute_name(:picture), Rails.root.join('test/fixtures/files/avatar.jpg')

    click_on I18n.t('helpers.submit.update')

    assert_text I18n.t('controllers.common.notice_update', name: Book.model_name.human)
    assert_text '黒猫の一日(改訂版)'
    assert_text '相変わらず猫かわいい'
    assert_text 'Kuro Nekosuke'
    assert_selector "img[src*='/uploads/book/picture/#{@book.id}/avatar.jpg']"
    click_on I18n.t('views.common.back', name: Book.model_name.human)
  end

  test 'should destroy Report' do
    visit book_url(@book)
    click_on I18n.t('views.common.destroy', name: Book.model_name.human), match: :first

    assert_text I18n.t('controllers.common.notice_destroy', name: Book.model_name.human)
    assert_selector 'h1', text: I18n.t('views.common.title_index', name: Book.model_name.human)
  end
end
