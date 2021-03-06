---
layout: post
title: Running background processes in PHP
new_url: https://florian.ec/articles/running-background-processes-in-php/
---

I often have long running tasks, for example, generating a report or performing an analysis of large amounts of data, that run minutes or even hours. Today I encountered a situation where I needed to start such task from a button in a browser window. Since the task takes three to five hours it was impossible to invoke the task directly.

My Internet research on this topic revelead a wide range of different solutions, from hacky to weird. The best I could find was the anwer of Mark Biek[^biek] to a question on Stack Overflow.

In PHP there are several functions to execute a command, for example, `exec` and `shell_exec`. However, there are several things to consider when a command should run in the background. But let's first take a look at the most simple example:

<pre><code class="php">shell_exec(sprintf('%s > /dev/null 2>&amp;1 &amp;', $command));
</code></pre>

There three important things in this snippet:

- The output (`STDOUT`) of the script must be directed to a file. In this case `> /dev/null` indicates that I'm not interested in the output.
- The errors (`STDERR`) also must be directed to a file. `2>&1` means that `STDERR` is redirected into `STDOUT` and therefore into the nirvana.
- The final `&` tells the command to execute in the background.

Of course it would also be possible to redirect `STDOUT` and `STDERR` to a file. In my situation this was not necessary since the command is part of an application with an internal log system.

Since the command will run multiple hours I'm also interested in the current status, that is, is the process still running. We can check if a process is running by using `ps`, for example:

<pre><code class="bash">ps $PID</code></pre>

In order to be able to look this up, we need the PID of the process. In a shell the PID of the last process is stored in the variable `$!` and we can pass it to PHP by echoing it.

<pre><code class="php">$pid = shell_exec(sprintf('%s > /dev/null 2>&amp;1 &amp; echo $!', $command));</code></pre>

It is now relatively easy to retrieve the status of the process. *The following code is taken directly from the already mentioned Stack Overflow question.*

    function isRunning($pid)
    {
        try {
            $result = shell_exec(sprintf('ps %d', $pid));
            if(count(preg_split("/\n/", $result)) > 2) {
                return true;
            }
        } catch(Exception $e) {}

        return false;
    }

At this point I have everything I need and the only thing left to do is pack the code in a class with an easy-to-use interface:

    namespace Bc\BackgroundProcess;

    class BackgroundProcess
    {
        private $command;
        private $pid;

        public function __construct($command)
        {
            $this->command = $command;
        }

        public function run($outputFile = '/dev/null')
        {
            $this->pid = shell_exec(sprintf(
                '%s > %s 2>&amp;1 &amp; echo $!',
                $this->command,
                $outputFile
            ));
        }

        public function isRunning()
        {
            try {
                $result = shell_exec(sprintf('ps %d', $this->pid));
                if(count(preg_split("/\n/", $result)) > 2) {
                    return true;
                }
            } catch(Exception $e) {}

            return false;
        }

        public function getPid()
        {
            return $this->pid;
        }
    }

It's now relatively easy to execute a command in a background process:

    use Bc\BackgroundProcess\BackgroundProcess;

    $process = new BackgroundProcess('sleep 5');
    $process->run();

    echo sprintf('Crunching numbers in process %d', $process->getPid());
    while ($process->isRunning()) {
        echo '.';
        sleep(1);
    }
    echo "\nDone.\n"

In this example the command `sleep 5` is executed in the background. As long as the process is running a dot is printed every second.

*Please note: If the parent process continues to run while the child process(es) run(s) in the background you should use a more robust solution, for example, the [Symfony Process](https://github.com/symfony/Process) component.*

**Update:** I created a library using the code above. You can find it on Github: [BcBackgroundProcess](https://github.com/braincrafted/background-process).

It is also possible to install the package through composer:

    {
        "require": {
            "braincrafted/background-process": "dev-master"
        }
    }

Feedback to this article is welcome. Please [email](mailto:florian@eckerstorfer.co) me or contact @braincrafted on [Twitter](http://twitter.com/braincrafted) or [App.net](https://alpha.app.net/braincrafted).

[^biek]: [Answer to "PHP execute a background process" on Stack Overflow](http://stackoverflow.com/a/45966/776654)
