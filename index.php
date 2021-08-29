<?php 
	session_start();
	require 'db.php';
?>

	<?php if(isset($_SESSION['uid'])): ?>
		Вы авторизованы! <br/>
		Привет, <?=$_SESSION['uid']['email']; ?>!<br/>
		Твой телефон: <?=$_SESSION['uid']['phone'];?><br/>
		<a href="logout.php">Выйти</a>
	<?php else:?>
		<button><a href="/login.php">Авторизация</a></button>
		<button><a href="/signup.php">Регистрация</a></button>
	<?php endif; ?>

<?php
	// echo '<pre>';
	// var_dump($_SESSION['uid']);
	// echo '</pre>';
