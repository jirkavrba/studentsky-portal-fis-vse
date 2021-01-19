# frozen_string_literal: true

require 'test_helper'

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :admin_user
    @subject = subjects(:one)
  end

  test 'should get index' do
    get subjects_url
    assert_response :success
  end

  test 'should get new' do
    get new_subject_url
    assert_response :success
  end

  test 'should create subject' do
    assert_difference('Subject.count') do
      post subjects_url, params: { subject: { code: @subject.code, name: @subject.name } }
    end

    assert_redirected_to subjects_url
  end

  test 'should get edit' do
    get edit_subject_url(@subject)
    assert_response :success
  end

  test 'should update subject' do
    patch subject_url(@subject), params: { subject: { code: @subject.code, name: @subject.name } }
    assert_redirected_to subjects_url
  end

  test 'should destroy subject' do
    assert_difference('Subject.count', -1) do
      delete subject_url(@subject)
    end

    assert_redirected_to subjects_url
  end
end
