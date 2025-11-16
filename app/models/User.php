<?php
class User {
    
    private $conn;
    private $table_name = "users";

    // ham khoi tao construct
    public function __construct($db){
        $this->conn=$db;
    }
// ham kiem tra dang nhap 
//dau vao dat $username va $password 
//dau ra mang array  thong tin user dang nhap neu dung  

public function login($username,$password){

    try{
// chuan bi sql

        $query = "SELECT * FROM". $this->table_name."WHERE username = :username LIMIT 1";   
// chuan bi prepare 
        $data = $this->conn->prepare($query);

// lam sach va gan bien bind()
        $username = htmlspecialchars(strip_tags($username));
        $data->bindParam(':username', $username );

// thuc thi
        $data ->execute();

if($data->rowCount() == 1){
    // lay user ra
    $row = $data ->fetch (PDO::FETCH_ASSOC);
                // 6. So sánh mật khẩu
                // password_verify sẽ so sánh mật khẩu người dùng gõ
                // với mật khẩu đã mã hóa (hash) trong CSDL
if(password_verify($password,$row['password'])){
                // Mật khẩu đúng!
    return $row;
        }
    }   
    return false;     
    }catch (PDOException $e){
        echo $e ->getMessage();
        return false;
    }
}


}

?>