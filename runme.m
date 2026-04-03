function runme(name, trigger, stim_set, num_runs, task_num, start_run, exec_runs)
% Prompts experimenter for session parameters and executes functional
% localizer experiment used to define regions in high-level visual cortex
% selective to faces, places, bodies, and printed characters.
%
% Inputs (optional):
%   1) name -- session-specific identifier (e.g., particpant's initials)
%   2) trigger -- option to trigger scanner (0 = no, 1 = yes)
%   3) stim_set -- stimulus set (1 = standard, 2 = alternate, 3 = both)
%   4) num_runs -- number of runs (stimuli repeat after 2 runs/set)
%   5) task_num -- which task (1 = 1-back, 2 = 2-back, 3 = oddball)
%   6) start_run -- run number to begin with (if sequence is interrupted)
%   7) exec_runs -- specific runs to execute (default = all)

%
% Version 3.0 8/2017
% Anthony Stigliani (astiglia@stanford.edu)
% Department of Psychology, Stanford University

% Modified 2026/03/31 by Lapluis


%% add paths and check inputs

addpath('functions');

% session name
if nargin < 1
    name = [];
    while isempty(deblank(name))
        name = input('Subject Name : ', 's');
    end
end

% option to trigger scanner
if nargin < 2
    trigger = 0;
    while ~ismember(trigger, 0:1)
        trigger = input('Trigger scanner? (0 = no, 1 = yes) : ');
    end
end

% which stimulus set/s to use
if nargin < 3
    stim_set = 3;
    while ~ismember(stim_set, 1:3)
        stim_set = input('Which stimulus set? (1 = standard, 2 = alternate, 3 = both) : ');
    end
end

% number of runs to generate
if nargin < 4
    num_runs = -1;
    while ~ismember(num_runs, 1:24)
        num_runs = input('How many runs? : ');
    end
end

% which task to use
if nargin < 5
    task_num = 1;
    while ~ismember(task_num, 1:3)
        task_num = input('Which task? (1 = 1-back, 2 = 2-back, 3 = oddball) : ');
    end
end

% which run number to begin executing (default = 1)
if nargin < 6
    start_run = -1;
    while ~ismember(start_run, 1:num_runs)
        start_run = input('Which run to start with? : ');
    end
end

% specific runs to execute (default = all)
if nargin < 7
    exec_runs = -1;
    while ~ismember(exec_runs, 1:(num_runs - start_run + 1))
        exec_runs = input('How many runs to execute : ');
    end
end

fprintf('Running fLoc experiment with the following parameters:\n');
fprintf('Subject name: %s\n', name);
fprintf('Trigger scanner: %d\n', trigger);
fprintf('Stimulus set: %d\n', stim_set);
fprintf('Number of runs: %d\n', num_runs);
fprintf('Task Type: %d\n', task_num);
fprintf('Starting with run: %d\n', start_run);
fprintf('Number of runs to execute: %d\n', exec_runs);


%% initialize session object and execute experiment

% setup fLocSession and save session information
session = fLocSession(name, trigger, stim_set, num_runs, task_num);
session = load_seqs(session);
session_dir = (fullfile(session.exp_dir, 'data', session.id));
if ~exist(session_dir, 'dir') == 7
    mkdir(session_dir);
end
fpath = fullfile(session_dir, [session.id '_fLocSession.mat']);
save(fpath, 'session', '-v7.3');

% execute all runs from start_run to num_runs and save parfiles
fname = [session.id '_fLocSession.mat'];
fpath = fullfile(session.exp_dir, 'data', session.id, fname);
for rr = start_run:(exec_runs + start_run - 1)
    fprintf('Executing run %d of %d...\n', rr, num_runs);
    session = run_exp(session, rr);
    save(fpath, 'session', '-v7.3');
end
write_parfiles(session);

end
