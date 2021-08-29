<?php
session_start();

require 'db.php';

if(isset($_SESSION['uid'])){
    header('location: /');
}

# проверяем какой метод используется на веб странице, если не POST завершаем обработку
if ($_SERVER['REQUEST_METHOD'] == 'POST')
{
    # подготавливаем данные из формы фильтруем их	
    $rulles = [
        'email'    => FILTER_VALIDATE_EMAIL,
        'password' => FILTER_DEFAULT
    ];
    # фильтруем данные при необходимости
    $filter = filter_input_array(INPUT_POST, $rulles);

    # создадим пустой массив, для хранения ошибок
    $errors = [];
    
    # проверяем пустоту email и пароль
    if (empty($filter['email']) && empty($filter['password'])) {
        $errors[] = 'введите email и пароль';
    }

    # проверка существования email  в базе
    $sql = $pdo -> prepare('SELECT `password` FROM `users` WHERE `email` = ?');
    $sql -> execute([$filter['email']]);
    $result = $sql -> fetch();

    # проверяем хеш от пароля, если не равно хешу из базы ошибка
    if (!password_verify($filter['password'], $result['password'])) {
        $errors[] = 'email или пароль не правильный';
    }

    # если количество ошибок больше нуля показываем их
    if(count($errors) > 0){
        echo '<div id="errors" style="color:red;">' .array_shift($errors). '</div><hr>';
    }else{
        # авторизация

        $sql = $pdo -> prepare('SELECT `user_id`, `email`, `phone` FROM `users` WHERE `email` = ?');
        $sql -> execute([$filter['email']]);
        $result = $sql -> fetch();

        # записываем в сессию все данные полученные из базы
        $_SESSION['uid'] = $result;
        
        header('location: /');
        exit();
    }
}

?>


<!DOCTYPE HTML>
<HEAD>
<meta charset="utf-8">
<link rel="stylesheet" href="style.css">
</HEAD>
<BODY>
<br><br><br>
<form action="login.php" method="POST" >
<strong>Телефон или адрес эл.почты</strong>
<p>
<input type="text" name="email" value="<?=$filter['email']; ?>"><br/>
<p>
<strong>Пароль</strong>
<p>
<input type="password" name="password" value="<?=$filter['password']; ?>"><br/>
<p>
<button type="submit" name="do_login">Войти</button>
</form>
</BODY>
</HTML>