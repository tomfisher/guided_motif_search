% Computes the accuracy of AV_complexity method
% Hoang Anh Dau Feb 18, 2017
%
% [accuracy] = test_AV_complexity(data, motif_location, subsequenceLength)
% Output:
%     accuracy: the accuracy (percentage)
% Input:
%     data: input time series (vector)
%     motifLocation: Groundtruth / The location of the embedded motif
%     subsequenceLength: motif length (scalar)
%
% This function is intended to be generic.
% It is originally written to test the performance of the proposed method
% on MALLAT dataset. The dataset and motif location are provided with your download.
% The experiment results are presented in Table 4 of the paper
%
function [accuracy] = test_AV_complexity(data, motifLocation, subsequenceLength)

% computes the matrix profile and profile index 
no_of_objects = size(data, 1);
for i = 1:no_of_objects
    [MP, MP_index] = Time_series_Self_Join_Fast(data(i, :), subsequenceLength);
end

score = zeros(1, size(MP, 1));
for i = 1:size(MP, 1)
    AV = make_AV_complexity(data(i,:), subsequenceLength);
    AV = AV';
    MP_corrected = correct_MP(MP(i,:), AV);
    
    [~, mii] = min(MP_corrected);
    top_m1 = mii;
    top_m2 = MP_index(i, mii);
    if top_m1 > top_m2; tmp = top_m1; top_m1 = top_m2; top_m2 = tmp; end; %sort
    
    actual_m1 = motifLocation(i, 1);
    actual_m2 = motifLocation(i, 2);
    if actual_m1 > actual_m2; tmp = actual_m1; actual_m1 = actual_m2; actual_m2 = tmp; end
    
    overlap1 = intersect(top_m1:top_m1 + subsequenceLength - 1, actual_m1:actual_m1+subsequenceLength - 1);
    overlap2 = intersect(top_m2:top_m2 + subsequenceLength - 1, actual_m2:actual_m2+subsequenceLength - 1);
    
    if length(overlap1) + length(overlap2) > 0
        score(i) = 1;
    end
end

accuracy = sum(score) / size(MP, 1);
disp(['Accuracy is ' num2str(accuracy)]);
end

%%
function [AV] = make_AV_complexity(data, subsequenceLength)
data = zscore(data); % data is a row vector
profile_length = length(data) - subsequenceLength + 1;
AV = zeros(profile_length,1);
for j = 1: profile_length
    AV(j) = check_complexity(data(j:j+subsequenceLength-1));
end
AV = zeroOneNorm(AV);
end

%%
function [complexity] = check_complexity(x)
complexity = sqrt(sum(diff(x).^2));
end

%%
function [MP_corrected] = correct_MP(matrix_profile, annotationVector)
MP_corrected = matrix_profile + (1 - annotationVector) * max(matrix_profile);
end

%%
function x = zeroOneNorm(x)
x = x-min(x);
x = x/max(x);
end