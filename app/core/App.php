<?php
/**
 * Xử lý Routing (ánh xạ URL -> Controller/Action)
 */
class App
{
    protected $controller = 'CourseController';
    protected $method = 'index';
    protected $params = [];

    public function __construct()
    {
        $url = $this->parseUrl();

        // Kiểm tra Controller
        if (isset($url[0]) && !empty($url[0])) {
            $controllerName = $this->getControllerName($url[0]);
            if (file_exists(APP_PATH . '/controllers/' . $controllerName . '.php')) {
                $this->controller = $controllerName;
                unset($url[0]);
            }
        }

        require_once APP_PATH . '/controllers/' . $this->controller . '.php';
        $this->controller = new $this->controller;

        // Kiểm tra Method
        if (isset($url[1])) {
            if (method_exists($this->controller, $url[1])) {
                $this->method = $url[1];
                unset($url[1]);
            }
        }

        // Lấy các tham số
        $this->params = $url ? array_values($url) : [];

        // Gọi controller method với params
        call_user_func_array([$this->controller, $this->method], $this->params);
    }

    /**
     * Chuyển đổi URL segment thành tên Controller
     */
    protected function getControllerName($segment)
    {
        // Map các URL segments phổ biến
        $mapping = [
            'courses' => 'CourseController',
            'students' => 'StudentController',
            'teachers' => 'TeacherController',
            'auth' => 'AuthController',
            'user' => 'UserController'
        ];

        if (isset($mapping[$segment])) {
            return $mapping[$segment];
        }

        // Mặc định: viết hoa chữ cái đầu và thêm Controller
        return ucfirst($segment) . 'Controller';
    }

    protected function parseUrl()
    {
        if (isset($_GET['url'])) {
            return explode('/', filter_var(rtrim($_GET['url'], '/'), FILTER_SANITIZE_URL));
        }
        return [];
    }
}

