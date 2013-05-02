<?php

require_once __DIR__.'/vendor/autoload.php';

$loop   = React\EventLoop\Factory::create();
$socket = new React\Socket\Server($loop);

$processFactory = new \Bc\BackgroundProcess\Factory('\Bc\BackgroundProcess\BackgroundProcess');

$socket->on('connection', function (\React\Socket\ConnectionInterface $conn) use ($processFactory) {
    $conn->on('data', function ($data) use ($conn, $processFactory) {
        $command = sprintf('php consumer.php "%s"', addslashes(trim($data)));
        $processFactory->newProcess($command)->run();

        $conn->close();
    });
});

$socket->listen(4000);
$loop->run();
