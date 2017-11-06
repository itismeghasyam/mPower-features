%% Testing the efficacy of the log spectral distance feature 
% Parkinson's tremor Analysis
% Used Health codes : syn11025972 (As of Nov 6, 2017)
% Data from : syn10676309

% Workspace, figure and console clean up
clear all;
close all;
clc;

nfft = 4096; % For uniformity in FFTs calculated as signals will have different lengths

% Controls
% Your filepaths etc., to read accelerometer signals
[fileids,filepaths,~] = unwrapfilemap('filepathmap_handToNose_left_control_latest.json');
[fileids2,filepaths2,~] = unwrapfilemap('filepathmap_handToNose_right_control_latest.json');
npatients = length(fileids);

% The 8 because, of xA,yA,zA,xG,yG,zG,net_accelA,net_accelG
% Where A: Accelerometer and G: Gyroscope
control_feature_mat = zeros(npatients,8);

for patient_no = 1:npatients
     % left hand
     [xAL,yAL,zAL,xGL,yGL,zGL,~] = unwrapjsonall(filepaths{patient_no});
     % right hand
     [xAR,yAR,zAR,xGR,yGR,zGR,~] = unwrapjsonall(filepaths2{patient_no});
     % net acceleration (user acceleration)
     net_accelAL = sqrt(xAL.^2+yAL.^2+zAL.^2);
     net_accelAR = sqrt(xAR.^2+yAR.^2+zAR.^2);
     net_accelGL = sqrt(xGL.^2+yGL.^2+zGL.^2);
     net_accelGR = sqrt(xGR.^2+yGR.^2+zGR.^2);
     
%      Making all signals unit norm (Normalizing signals)
%########################################################
%  uncomment below to normalize signals
%      xAL = xAL/norm(xAL); xAR = xAR/norm(xAR); 
%      yAL = yAL/norm(yAL); yAR = yAR/norm(yAR);
%      zAL = zAL/norm(zAL); zAR = zAR/norm(zAR);
%      net_accelAL = net_accelAL/norm(net_accelAL);
%      net_accelAR = net_accelAR/norm(net_accelAR);
% 
%      xGL = xGL/norm(xGL); xGR = xGR/norm(xGR); 
%      yGL = yGL/norm(yGL); yGR = yGR/norm(yGR);
%      zGL = zGL/norm(zGL); zGR = zGR/norm(zGR);
%      net_accelGL = net_accelGL/norm(net_accelGL);
%      net_accelGR = net_accelGR/norm(net_accelGR);
%########################################################

    control_feature_mat(patient_no,:) = [logspecdist(xAL,xAR,nfft) ...
        logspecdist(yAL,yAR,nfft) logspecdist(zAL,zAR,nfft) logspecdist(xGL,xGR,nfft) ...
        logspecdist(yGL,yGR,nfft) logspecdist(zGL,zGR,nfft) ...
        logspecdist(net_accelAL,net_accelAR,nfft) logspecdist(net_accelGL,net_accelGR,nfft)]; 
end

% Parkinsons
[fileids,filepaths,~] = unwrapfilemap('filepathmap_handToNose_left_parkinson_latest.json');
[fileids2,filepaths2,~] = unwrapfilemap('filepathmap_handToNose_right_parkinson_latest.json');
npatients = length(fileids);
parkinson_feature_mat = zeros(npatients,8);

for patient_no = 1:npatients
     % left hand
     [xAL,yAL,zAL,xGL,yGL,zGL,~] = unwrapjsonall(filepaths{patient_no});
     % right hand
     [xAR,yAR,zAR,xGR,yGR,zGR,~] = unwrapjsonall(filepaths2{patient_no});
     % net acceleration (user acceleration)
     net_accelAL = sqrt(xAL.^2+yAL.^2+zAL.^2);
     net_accelAR = sqrt(xAR.^2+yAR.^2+zAR.^2);
     net_accelGL = sqrt(xGL.^2+yGL.^2+zGL.^2);
     net_accelGR = sqrt(xGR.^2+yGR.^2+zGR.^2);
     
%      Making all signals unit norm (Normalizing signals)
%########################################################
%  uncomment below to normalize signals
%      xAL = xAL/norm(xAL); xAR = xAR/norm(xAR); 
%      yAL = yAL/norm(yAL); yAR = yAR/norm(yAR);
%      zAL = zAL/norm(zAL); zAR = zAR/norm(zAR);
%      net_accelAL = net_accelAL/norm(net_accelAL);
%      net_accelAR = net_accelAR/norm(net_accelAR);
% 
%      xGL = xGL/norm(xGL); xGR = xGR/norm(xGR); 
%      yGL = yGL/norm(yGL); yGR = yGR/norm(yGR);
%      zGL = zGL/norm(zGL); zGR = zGR/norm(zGR);
%      net_accelGL = net_accelGL/norm(net_accelGL);
%      net_accelGR = net_accelGR/norm(net_accelGR);
%########################################################
     
     parkinson_feature_mat(patient_no,:) = [logspecdist(xAL,xAR,nfft) ...
        logspecdist(yAL,yAR,nfft) logspecdist(zAL,zAR,nfft) logspecdist(xGL,xGR,nfft) ...
        logspecdist(yGL,yGR,nfft) logspecdist(zGL,zGR,nfft) ...
        logspecdist(net_accelAL,net_accelAR,nfft) logspecdist(net_accelGL,net_accelGR,nfft)]; 
end


% Random Forest Classifier
echo off;
auc_vec = [];
imp_mat = []; % predictor importance matrix
max_instances = 10000;
g = struct;
g.ShowPlots = false;
g.Verbose = 0;

for instance_no = 1:max_instances
    
xl_feat_control = control_feature_mat';
xl_feat_parkinson = parkinson_feature_mat';

% Test vs Training split
n_training = 83; % test
n_peeps = 100; % total
a_vec = 1:n_peeps;
indices_vec_c = randsample(n_peeps, n_training);
indices_vec_p = randsample(n_peeps, n_training);
xl_mat = [xl_feat_control(:,indices_vec_c)'; xl_feat_parkinson(:,indices_vec_p)'];

xl_test_mat = [xl_feat_control(:,setdiff(a_vec,indices_vec_c))'; xl_feat_parkinson(:, setdiff(a_vec,indices_vec_p))'];

out_vec = ([0*ones(n_training,1); ones(n_training,1)]);

tree = fitctree(xl_mat, out_vec,'MinParentSize',20);
[ypred,score,~,~] = predict(tree,xl_test_mat);
number_vec = [repmat('c',[n_peeps-n_training,1]);repmat('p',[n_peeps-n_training,1])]; 

[X,Y,T,AUC,OPTROCPT] = perfcurve(number_vec,score(:,2),'p');
imp = predictorImportance(tree);
imp_mat = [imp_mat imp(:)];
auc_vec = [auc_vec; AUC];

end


figure;
boxplot(auc_vec);
title(['mean AUC(LSD Features): ' num2str(mean(auc_vec))]);

figure;
bar(mean(imp_mat,2));
title('Mean Predictor Importance Estimates');
ylabel('Estimates');
xlabel('Predictors');
h = gca;
h.XTickLabel = {'xA','yA','zA','xG','yG','zG','net_accelA','net_accelG'};
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';