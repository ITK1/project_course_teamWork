<?php
/**
 * Xử lý Kết nối CSDL
 */
class Database
{
    private static $instance = null;
    private $connection;

    private $host = 'localhost';
    private $dbname = 'project_course';
    private $username = 'root';
    private $password = '';

    private function __construct()
    {
        try {
            $this->connection = new PDO(
                "mysql:host={$this->host};dbname={$this->dbname};charset=utf8mb4",
                $this->username,
                $this->password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                ]
            );
        } catch (PDOException $e) {
            die("Database connection failed: " . $e->getMessage());
        }
    }

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection()
    {
        return $this->connection;
    }

    // Ngăn chặn clone
    private function __clone() {}

    // Ngăn chặn unserialize
    public function __wakeup()
    {
        throw new Exception("Cannot unserialize singleton");
    }
}

