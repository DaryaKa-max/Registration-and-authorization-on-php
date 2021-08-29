-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Сен 22 2020 г., 21:42
-- Версия сервера: 10.3.22-MariaDB
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `clothing store`
--

-- --------------------------------------------------------

--
-- Структура таблицы `colors`
--

CREATE TABLE `colors` (
  `id` int(11) NOT NULL COMMENT 'Идентификатор цвета',
  `name` varchar(50) NOT NULL COMMENT 'Название цвета'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `compositions`
--

CREATE TABLE `compositions` (
  `id` int(11) NOT NULL COMMENT 'Идентификатор ткани',
  `name` varchar(50) NOT NULL COMMENT 'Название вида ткани'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `discounts`
--

CREATE TABLE `discounts` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ записи',
  `id_user` int(11) NOT NULL COMMENT 'Идентификатор покупателя, совершившего заказ',
  `volume` int(11) NOT NULL COMMENT 'Минимальная сумму покупок за месяц для получения соответствующей скидки',
  `percent` int(11) NOT NULL COMMENT 'Размер скидки в процентах (от 0 до 20)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `goods`
--

CREATE TABLE `goods` (
  `id` int(11) NOT NULL COMMENT 'Идентификатор товара',
  `name` varchar(255) NOT NULL COMMENT 'Название товара',
  `photo` varchar(255) NOT NULL COMMENT 'Путь в файловой системе к файлу с фотографией',
  `id_color` int(11) NOT NULL COMMENT 'Идентификатор цвета товара данной спецификации',
  `id_composition` int(11) NOT NULL COMMENT 'Идентификатор вида ткани, присутствующей в составе в данной спецификации',
  `price` int(11) NOT NULL COMMENT 'Продажная цена товара'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ заказа',
  `id_user` int(11) DEFAULT NULL COMMENT 'Идентификатор покупателя, совершившего заказ',
  `status` enum('formed','payed','cancelled') NOT NULL COMMENT 'Данное поле хранит одно из возможных состояний заказа: «оформлен», «оплачен», «аннулирован»',
  `created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Дата и время заказа',
  `payed` timestamp NULL DEFAULT NULL COMMENT 'Дата и время оплаты'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `positions`
--

CREATE TABLE `positions` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ позиции товара в заказе',
  `id_order` int(11) NOT NULL COMMENT 'Идентификатор заказа, к которому относится данная позиция',
  `id_spec` int(11) NOT NULL COMMENT 'Идентификатор спецификации товара, который заказал пользователь',
  `qty` int(11) NOT NULL COMMENT 'Количество единиц товара данной спецификации в заказе',
  `price` int(11) NOT NULL COMMENT 'Продажная цена одной единицы товара'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `provider`
--

CREATE TABLE `provider` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ поставщика',
  `name` varchar(255) NOT NULL COMMENT 'Наименование поставщика',
  `street` varchar(255) NOT NULL COMMENT 'Улица, на которой находится офис поставщика',
  `house number` varchar(255) NOT NULL COMMENT 'Номер дома улицы, на которой находится офис поставщика',
  `office number` varchar(255) NOT NULL COMMENT 'Номер офиса (кабинета)поставщика',
  `phone` varchar(20) NOT NULL COMMENT 'Телефон поставщика',
  `last_name` varchar(50) NOT NULL COMMENT 'Фамилия контактного лица со стороны поставщика',
  `first_name` varchar(50) NOT NULL COMMENT 'Имя контактного лица со стороны поставщика'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ закупки',
  `id_spec` int(11) NOT NULL COMMENT 'Идентификатор спецификации товара, который закупается',
  `id_provider` int(11) NOT NULL COMMENT 'Идентификатор поставщика, у которого происходит закупка',
  `qty` int(11) NOT NULL COMMENT 'Количество единиц данного товара в закупке',
  `price` int(11) NOT NULL COMMENT 'Цена за единицу данного товара в закупке',
  `date` date NOT NULL COMMENT 'Дата закупки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `specifications`
--

CREATE TABLE `specifications` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ спецификации товара',
  `id_goods` int(11) NOT NULL COMMENT 'Идентификатор товара, к которому относится данная спецификация',
  `size` int(11) NOT NULL COMMENT 'Размер товара в данной спецификации'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `types`
--

CREATE TABLE `types` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ типа пользователя',
  `name` varchar(50) NOT NULL COMMENT 'Полное название типа пользователя (гость,покупатель без личного кабинета,покупатель с личный кабинетом, менеджер по продажам,владелец магазина,системный администратор)',
  `short_name` varchar(50) NOT NULL COMMENT 'Сокращённое название типа пользователя(покупатель,менеджер, владелец, админ)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `types`
--

INSERT INTO `types` (`id`, `name`, `short_name`) VALUES
(1, 'Гость', ''),
(2, 'Покупатель без личного кабинета', ''),
(3, 'Покупатель с личным кабинетом', 'покупатель'),
(4, 'Менеджер по продажам', 'менеджер'),
(5, 'Владелец', 'владелец'),
(6, 'Сервисный администратор', 'админ');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL COMMENT 'Первичный ключ пользователя',
  `last_name` varchar(50) DEFAULT NULL COMMENT 'Фамилию пользователя',
  `first_name` varchar(50) DEFAULT NULL COMMENT 'Имя пользователя',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Телефон пользователя',
  `email` varchar(70) NOT NULL COMMENT 'Электронную почту пользователя',
  `password` varchar(32) NOT NULL COMMENT 'Пароль пользователя',
  `discount` int(11) NOT NULL DEFAULT 0 COMMENT 'Скидка пользователя в процентах (от 0 до 20)',
  `id_type` int(11) NOT NULL COMMENT 'Идентификатор типа пользователя'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `colors`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `compositions`
--
ALTER TABLE `compositions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `discounts_user` (`id_user`);

--
-- Индексы таблицы `goods`
--
ALTER TABLE `goods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `goods_color` (`id_color`),
  ADD KEY `goods_composition` (`id_composition`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `order_user` (`id_user`);

--
-- Индексы таблицы `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_order_2` (`id_order`,`id_spec`),
  ADD KEY `id_order` (`id_order`),
  ADD KEY `id_spec` (`id_spec`),
  ADD KEY `price` (`price`);

--
-- Индексы таблицы `provider`
--
ALTER TABLE `provider`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_spec` (`id_spec`),
  ADD KEY `id_provider` (`id_provider`);

--
-- Индексы таблицы `specifications`
--
ALTER TABLE `specifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `size` (`size`),
  ADD KEY `id_goods` (`id_goods`);

--
-- Индексы таблицы `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id_type` (`id_type`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `colors`
--
ALTER TABLE `colors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор цвета';

--
-- AUTO_INCREMENT для таблицы `compositions`
--
ALTER TABLE `compositions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор ткани';

--
-- AUTO_INCREMENT для таблицы `discounts`
--
ALTER TABLE `discounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ записи';

--
-- AUTO_INCREMENT для таблицы `goods`
--
ALTER TABLE `goods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор товара';

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ заказа';

--
-- AUTO_INCREMENT для таблицы `positions`
--
ALTER TABLE `positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ позиции товара в заказе';

--
-- AUTO_INCREMENT для таблицы `provider`
--
ALTER TABLE `provider`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ поставщика';

--
-- AUTO_INCREMENT для таблицы `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ закупки';

--
-- AUTO_INCREMENT для таблицы `specifications`
--
ALTER TABLE `specifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ спецификации товара';

--
-- AUTO_INCREMENT для таблицы `types`
--
ALTER TABLE `types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ типа пользователя', AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ пользователя';

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `discounts`
--
ALTER TABLE `discounts`
  ADD CONSTRAINT `discounts_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `goods`
--
ALTER TABLE `goods`
  ADD CONSTRAINT `goods_color` FOREIGN KEY (`id_color`) REFERENCES `colors` (`id`),
  ADD CONSTRAINT `goods_composition` FOREIGN KEY (`id_composition`) REFERENCES `compositions` (`id`);

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `order_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `positions`
--
ALTER TABLE `positions`
  ADD CONSTRAINT `position_order` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `position_spec` FOREIGN KEY (`id_spec`) REFERENCES `specifications` (`id`);

--
-- Ограничения внешнего ключа таблицы `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchase_provider` FOREIGN KEY (`id_provider`) REFERENCES `provider` (`id`),
  ADD CONSTRAINT `purchase_spec` FOREIGN KEY (`id_spec`) REFERENCES `specifications` (`id`);

--
-- Ограничения внешнего ключа таблицы `specifications`
--
ALTER TABLE `specifications`
  ADD CONSTRAINT `spec_goods` FOREIGN KEY (`id_goods`) REFERENCES `goods` (`id`);

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `user_type` FOREIGN KEY (`id_type`) REFERENCES `types` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
