
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../public/assets/css/style.css">
</head>
<body>
    <div id="login">
        <div class="login-main">
            <div class="login-container">
                <div class="header-text">
                    <div class="h1">Hello, Welcom!</div>
                    <div class="no-tk">
                        <div ><a href="index.php?controller=auth&action=register">Chưa có tài khoản</a></div>
                    </div>
                        <button class="btn-register">register</button>
            </div>

        <div class="login-login">
        <div class="login-header">Login</div>
        <?php 
        // Hiển thị thông báo lỗi hoặc trạng thái (Ví dụ: "Sai mật khẩu", "Chờ Admin duyệt")
        if (!empty($message)): 
        ?>
        <p class="message"><?php echo htmlspecialchars($message); ?></p>
        <?php endif; ?>
            
        <form
          action="index.php?controller=auth&action=processLogin" method="POST"> 
          <h2> Đăng Nhập</h2>
          <?php 
// Nếu Controller gửi sang biến $error, ta sẽ hiển thị nó ở đây
        if (isset($error) && !empty($error)): ?>
        <div class="error"><?php echo htmlspecialchars($error); ?></div>
        <?php endif; ?>


            <div class="form-group">
                <label for="username">Tên Đăng Nhập</label>
              <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password"> Mật Khẩu</label>
              <input type="password" id="password" name="password" required>
            </div>
            
          <!-- <div class="login-group">
            <div class="forgot-pass">
              <a href="">Quên mật khẩu</a> -->
            <!-- </div> -->
            <div class="btn-login"><button type="submit" >Login</button></div>
          </div>
          </div>
          
          
        </form>

        
            </div>
        </div>
    </div>
</body>

</html>

