require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest
  test "login form is shown before login" do
    get root_path
    assert_response :success
    assert_select "form[action=?]", top_login_path
    assert_select "input[name=uid]"
    assert_select "input[name=pass][type=password]"
  end

  test "registered credentials keep login in the session" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    assert_redirected_to top_main_path
    follow_redirect!
    assert_select "p", "ログイン成功"
    get root_path
    assert_select "p", "ログイン成功"
    assert_select "form", count: 0
  end

  test "another registered user can login" do
    post top_login_path, params: { uid: "student", pass: "practice" }
    assert_redirected_to top_main_path
    follow_redirect!
    assert_select "p", "ログイン成功"
  end

  test "unregistered or mismatched credentials use the same error" do
    [{ uid: "wrong", pass: "sanriko" }, { uid: "kindai", pass: "wrong" }, { uid: "student", pass: "sanriko" }, { uid: "", pass: "" }].each do |credentials|
      post top_login_path, params: credentials
      assert_response :success
      assert_select "p", "ログイン失敗"
      assert_select "p", "IDまたはパスワードが違います"
      get root_path
      assert_select "form[action=?]", top_login_path
    end
  end

  test "logout link deletes login state" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    follow_redirect!
    assert_select "a[href=?]", top_logout_path, text: "ログアウト"
    get top_logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "form[action=?]", top_login_path
    get top_main_path
    assert_select "form[action=?]", top_login_path
    assert_select "p", text: "ログイン成功", count: 0
  end
end
