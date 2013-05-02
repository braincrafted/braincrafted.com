<?php

function consume($message, $filename)
{
    for ($i = 0; $i < 5; $i++) {
        $data = sprintf("%s: Do something with %s\n", date('H:i:s'), $message);
        file_put_contents($filename, $data, FILE_APPEND);
        sleep(1);
    }
}

$message = stripslashes($_SERVER['argv'][1]);
consume($message, "message.log");
