<?php
/**
 * Session Helper
 * Quản lý session một cách an toàn
 */
class Session
{
    /**
     * Khởi động session nếu chưa được khởi động
     */
    public static function start()
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    /**
     * Lấy giá trị session
     */
    public static function get($key, $default = null)
    {
        self::start();
        return $_SESSION[$key] ?? $default;
    }

    /**
     * Set giá trị session
     */
    public static function set($key, $value)
    {
        self::start();
        $_SESSION[$key] = $value;
    }

    /**
     * Xóa giá trị session
     */
    public static function remove($key)
    {
        self::start();
        if (isset($_SESSION[$key])) {
            unset($_SESSION[$key]);
        }
    }

    /**
     * Xóa tất cả session
     */
    public static function destroy()
    {
        self::start();
        session_destroy();
    }

    /**
     * Kiểm tra session có tồn tại không
     */
    public static function has($key)
    {
        self::start();
        return isset($_SESSION[$key]);
    }
}

