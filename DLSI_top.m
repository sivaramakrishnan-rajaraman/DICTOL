function DLSI_top(dataset, N_train, k, lambda, eta)
    addpath(genpath('utils'));  
    addpath(genpath('DLSI'));      
    addpath('ODL')
    %% test mode 
    if nargin == 0 
        dataset = 'myARgender';
        N_train = 40;
        k = 25;
        lambda = 0.001;
        eta = 0.1;
    end 
    %%
    t = getTimeStr();
    [dataset, Y_train, Y_test, label_train, label_test] = train_test_split(...
        dataset, N_train);
    if ~exist('results', 'dir')
        mkdir('results');
    end 
    if ~exist(fullfile('results', 'DLSI'), 'dir')
        mkdir('results', 'DLSI');
    end 
    fn = fullfile('results', 'DLSI', strcat(dataset, '_N_', num2str(N_train), ...
        '_k_', num2str(k), '_l_', num2str(lambda), '_e_', num2str(eta), '_', ...
        t, '.mat'));
    disp(fn);
    
    C              = max(label_train);
    D_range        = k*(0:C);
    opts.lambda    = lambda;
    opts.eta       = eta;
    opts.D_range   = D_range;
    opts.show_cost = 0;
    train_range    = label_to_range(label_train);
    opts.show      = 0;
    opts.verbal    = true;
    opts.max_iter  = 100;        
    %% ========= Train ==============================
    [D, X, rt]         = DLSI(Y_train, train_range, opts);
    %% ========= test ==============================
    pred           = DLSI_pred(Y_test, D, opts);
    acc            = double(sum(pred == label_test))/numel(label_test);
    disp(['acc = ', num2str(acc)]);
    disp(fn);    
    if strcmp(dataset, 'mySynthetic')
        save(fn, 'D', 'X', 'k', 'acc', 'rt');
    else 
        save(fn, 'acc', 'rt');
    end 
end 

