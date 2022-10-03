SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `url_slug` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `content` mediumtext NOT NULL,
  `submit_time` datetime NOT NULL DEFAULT current_timestamp(),
  `notification_seen` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `introduction` varchar(255) DEFAULT NULL,
  `content` mediumtext NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT current_timestamp(),
  `last_modified` datetime NOT NULL DEFAULT current_timestamp(),
  `is_published` tinyint(1) NOT NULL DEFAULT 0,
  `url_slug` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `remembered_logins` (
  `token_hash` varchar(64) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expiration_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `settings` (
  `name` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `settings` (`name`, `value`) VALUES
('blog_description', 'This is my blog'),
('blog_name', 'MyBlog'),
('facebook_profile', NULL),
('footer_text', '© 2020 Copyright'),
('instagram_profile', NULL),
('twitter_profile', NULL),
('youtube_profile', NULL);

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(25) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT 2,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `activation_hash` varchar(64) DEFAULT NULL,
  `password_reset_hash` varchar(64) DEFAULT NULL,
  `password_reset_expiry` datetime DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `join_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `user_roles` (`id`, `name`) VALUES
(1, 'Administrator'),
(2, 'User');

ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `url_slug` (`url_slug`),
  ADD KEY `parent_id` (`parent_id`);

ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `url_slug` (`url_slug`),
  ADD KEY `FK_Post_User` (`user_id`),
  ADD KEY `FK_Post_Category` (`category_id`);

ALTER TABLE `remembered_logins`
  ADD PRIMARY KEY (`token_hash`),
  ADD KEY `user_id` (`user_id`);

ALTER TABLE `settings`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`,`email`),
  ADD UNIQUE KEY `password_reset_hash` (`password_reset_hash`),
  ADD UNIQUE KEY `activation_hash` (`activation_hash`),
  ADD KEY `role_id` (`role_id`);

ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `user_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

ALTER TABLE `posts`
  ADD CONSTRAINT `FK_Post_Category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Post_User` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE `remembered_logins`
  ADD CONSTRAINT `FK_RememberedLogin_User` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `users`
  ADD CONSTRAINT `FK_User_UserRole` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;
