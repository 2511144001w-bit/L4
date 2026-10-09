require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest
  test "login form is shown before login" do
    get root_path
    assert_response :success
    assert_select "form[action=?]", top_login_path
    assert_select "input[name=uid]"
    assert_select "input[name=pass][type=password]"
  end

  test "correct fixed credentials keep login in the session" do
    post top_login_path, params: { uid: "kindai", pass: "sanriko" }
    assert_redirected_to top_main_path
    follow_redirect!
    assert_select "p", "ログイン成功"
    get root_path
    assert_select "p", "ログイン成功"
    assert_select "form", count: 0
  end

  test "incorrect ID and incorrect password have the same error" do
    [{ uid: "wrong", pass: "sanriko" }, { uid: "kindai", pass: "wrong" }, { uid: "", pass: "" }].each do |credentials|
      post top_login_path, params: credentials
      assert_response :success
      assert_select "p", "ログイン失敗"
      assert_select "p", "IDまたはパスワードが違います"
      get root_path
      assert_select "form[action=?]", top_login_path
    end
  end
end
