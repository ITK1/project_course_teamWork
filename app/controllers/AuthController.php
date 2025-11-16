<?php
require_once __DIR__ . '/../models/User.php';

class AuthController{
     private $db;
     private $userModel;

     public function __construct($conn){
        $this->db ==$conn;
        $this->userModel = new user($this->db);
     }

     public function login(){
        if($_SERVER(['REQUEST_METHOD']) === "POST"){
             // --- XỬ LÝ KHI NHẤN NÚT ---
             $username = $_POST['username'] ?? '';
             $password = $_POST['password'] ?? '';
             // 3. Nhờ Model kiểm tra
             $user = $this->userModel->login($username, $password);

             if($user){
               // 4. NẾU MODEL TRẢ VỀ LÀ ĐÚNG
               session_start();
               $_SESSION['user_id'] = $user['id'];
               $_SESSION['username'] = $user['username'];
               $_SESSION['role'] =  $user['role'];
               // Chuyển hướng tới trang admin (theo route của bạn)
               header("Location: index.php?page=admin");
               exit();
            }else{
               // 5. NẾU MODEL TRẢ VỀ LÀ SAI
                // Đặt một biến lỗi
                $error = "Tên đang nhập sai hoặc Mật Khẩu Tài Khoảng Không đúng";
                // tải lại views đăng nhập và truyện biến $error sang  
                require_once __DIR__ . '/../views/auth/login.php';
            }
             }else {
               // --- HIỂN THỊ FORM (Nếu là GET, tức là lần đầu truy cập) ---
               // Chỉ cần tải file view, không có lỗi
               require_once __DIR__ . '/../views/login.php';
           }
        }
/**
     * Hàm này được gọi bởi route 'logout' (page=logout)
     */
    public function logout() {
      session_start();
      session_destroy();
      header("Location: index.php?page=login"); // Chuyển về trang login
      exit();
  }
}

?>