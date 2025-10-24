#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include <errno.h>

void handle_signal(int sig);
void register_signals();
void reap_zombies();

volatile sig_atomic_t stop_signal = 0; 
pid_t child_pid = -1;

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <command> [args...]\n", argv[0]);
        return 1;
    }

    register_signals();

    child_pid = fork();
    if (child_pid < 0) {
        perror("fork");
        exit(EXIT_FAILURE);
    }

    if (child_pid ==  0) {
        execvp(argv[1], &argv[1]);
        perror("execvp");
        exit(EXIT_FAILURE);
    }

    int status;
    while (1) {
        pid_t pid = waitpid(child_pid, &status, 0);
        if (pid == -1) {
            if (errno == EINTR) {
                continue;
            }

            perror("waitpid");
            break;
        } else if (pid == child_pid) {
            break;
        }
    }

    reap_zombies();

    if (WIFEXITED(status)) {
        return WEXITSTATUS(status);
    } else if (WIFSIGNALED(status)) {
        return 128 + WTERMSIG(status);
    } else {
        return 1;
    }

    return 0;
}

void handle_signal(int sig) {
    if (sig == SIGCHLD) {
        reap_zombies();
    } else if (sig == SIGINT || sig == SIGTERM) {
        stop_signal = sig;
        if (child_pid > 0) {
            kill(child_pid, sig);
        }
    } else {
        fprintf(stderr, "Got unhandled signal %d\n", sig);
    }
}

void register_signals() {
    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);
    signal(SIGCHLD, handle_signal);
}

void reap_zombies() {
    while(waitpid(-1, NULL, WNOHANG) > 0);
}