<?php
session_start();

require 'db.php';

if(isset($_SESSION['uid']))
{
    header('location: /');
    exit();
}

# проверяем какой метод используется на веб странице, если не POST завершаем обработку
if ($_SERVER['REQUEST_METHOD'] == 'POST')
{
    # подготавливаем данные из формы фильтруем их	
    $rulles = [
        'lastname'   => FILTER_DEFAULT,
        'firstname'  => FILTER_DEFAULT,
        'email'      => FILTER_VALIDATE_EMAIL,
        'phone'      => FILTER_DEFAULT,
        'password_1' => FILTER_DEFAULT,
        'password_2' => FILTER_DEFAULT
    ];
    # фильтруем данные при необходимости
    $filter = filter_input_array(INPUT_POST, $rulles);

    # создадим пустой массив, для хранения ошибок
    $errors = [];

    # проверяем не пуста ли переменная имени
    if(empty($filter['lastname'])) {
        $errors[] = 'Введите имя!';
    }
    # проверяем не пуста ли переменная фамилии
    if(empty($filter['firstname'])) {
      $errors[] = 'Введите фамилию!';
    }
    # проверяем не пуста ли переменная email и заполнина она валидно
    if(empty($filter['email']) && !$filter['email']) {
      $errors[] = 'Email не валидный, пример email: example@ya.ru';
    }
    
    # проверка существования email в базе
    $sql = $pdo->prepare('SELECT `email` FROM `users` WHERE `email` = :email');
    $sql -> execute(['email' => $filter['email']]);
    $result = $sql -> fetch();

    if (!$result['email'] == false) {
        $errors[] = 'email существует выбери другой';
    }

    # проверяем не пуста ли переменная телефон
    if(empty($filter['phone'])) {
        $errors[] = 'Введите телефон!';
    }

    # проверка существования телефон в базе
    $sql = $pdo->prepare('SELECT `phone` FROM `users` WHERE `phone` = :phone');
    $sql -> execute(['phone' => $filter['phone']]);
    $result = $sql -> fetch();

    if (!$result['phone'] == false) {
        $errors[] = 'телефон существует выбери другой';
    }

    # проверяем не пуста ли переменная пароль
    if(empty($filter['password_1']))
    {
      $errors[] = 'Введите пароль!';
    }
    # проверяем совпадение паролей, если пароль1 не равен паролю2
    if($filter['password_1'] != $filter['password_2'])
    {
        $errors[] = 'Пароли не совпадают!';
    }

    # если количество ошибок больше нуля показываем их
    if(count($errors) > 0){
        echo '<div id="errors" style="color:red;">' .array_shift($errors). '</div><hr>';
    }else{
        #регистрация
        # перед регистрацией захешируем пароль который вставим в базу
        $pass = password_hash($filter['password_1'], PASSWORD_DEFAULT);

        $stmt = $pdo->prepare("INSERT INTO `users`(`last_name`, `first_name`, `phone`, `email`, `password`) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$filter['lastname'], $filter['firstname'], $filter['phone'], $filter['email'], $pass ]);

        echo '<div style="color:green;">Вы успешно зарегистрированы!</div><hr>';
        echo '<a href="/login.php">перейти на главную</a>';
    }
    // echo '<pre>';
	// var_dump($errors);
	// echo '</pre>';
}

?>
<!DOCTYPE HTML>
<head>
<meta charset="utf-8" />
    <link rel="stylesheet" href="style.css">
</head>
<body>
<form action="/signup.php" method="POST">
    <br><br><br>
    <strong>Ваше имя</strong>
    <input type="text" name="lastname" value="<?=$filter['lastname']; ?>">
    <p>
    <strong>Ваша фамилия</strong>
    <input type="text" name="firstname" value="<?=$filter['firstname']; ?>">
    <p>
    <strong>Ваш Email</strong>
    <input type="email" name="email" value="<?=$filter['email']; ?>">
    <p>
    <strong>Ваш номер телефона</strong>
    <input type="phone" name="phone" value="<?=$filter['phone']; ?>">
    <p>
    <strong>Ваш пароль</strong>
    <input type="password" name="password_1" value="<?=$filter['password_1']; ?>">
    <p>
    <strong>Повторите пароль*</strong>
    <input type="password" name="password_2" value="<?=$filter['password_2']; ?>">
 
    <strong><!--?php captcha_show(); ?--></strong>
    <p>
 
    <button type="submit" name="do_signup">Отправить</button>
</form>
</body>
</html>