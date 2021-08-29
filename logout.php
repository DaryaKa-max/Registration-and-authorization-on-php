<?php 
	session_start();

    # уничтожить всю запущеную сессию
    session_destroy();

    # удаляем информацию о пользователе из сессии
	unset($_SESSION['uid']);

	# перенаправляем пользователя на нужный url
	header('Location: /');
	exit();
