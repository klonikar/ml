%% Machine Learning Online Class - Exercise 3 | Part 1: One-vs-all

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  linear exercise. You will need to complete the following functions 
%  in this exericse:
%
%     lrCostFunction.m (logistic regression cost function)
%     oneVsAll.m
%     predictOneVsAll.m
%     predict.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
clear ; close all; clc

%% Setup the parameters you will use for this part of the exercise
input_layer_size  = 400;  % 20x20 Input Images of Digits
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  You will be working with a dataset that contains handwritten digits.
%

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

load('ex3data1.mat'); % training data stored in arrays X, y
m = size(X, 1);

% Randomly select 100 data points to display
rand_indices = randperm(m);
sel = X(rand_indices(1:100), :);

displayData(sel);

fprintf('Program paused. Press enter to continue.\n');
pause;

%% ============ Part 2: Vectorize Logistic Regression ============
%  In this part of the exercise, you will reuse your logistic regression
%  code from the last exercise. You task here is to make sure that your
%  regularized logistic regression implementation is vectorized. After
%  that, you will implement one-vs-all classification for the handwritten
%  digit dataset.
%

fprintf('\nTraining One-vs-All Logistic Regression...\n')

lambda = 0.5;
% Train on first t examples, then predict later rows(X)-t examples
t = 250;
num_samples_per_label = rows(X)/num_labels; % 500 images per digit
Xt = zeros(t*num_labels, columns(X));
yt = zeros(t*num_labels,1);
for i = 1:num_labels
    Xt((i-1)*t+1:i*t,:) = X(num_samples_per_label*(i-1)+1:num_samples_per_label*(i-1)+t,:);
    yt((i-1)*t+1:i*t,:) = y(num_samples_per_label*(i-1)+1:num_samples_per_label*(i-1)+t,:);

end
%Xt = X;
%yt = y;
[all_theta] = oneVsAll(Xt, yt, num_labels, lambda);

displayData(all_theta(:, 2:end));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 3: Predict for One-Vs-All ================
%  After ...
remainder = num_samples_per_label - t;
Xremainder = zeros(remainder*num_labels, columns(X));
yremainder = zeros(remainder*num_labels, 1);
for i=1:num_labels
    Xremainder((i-1)*remainder+1:i*remainder,:) = X((i-1)*num_samples_per_label+1+t:i*num_samples_per_label,:);
    yremainder((i-1)*remainder+1:i*remainder,:) = y((i-1)*num_samples_per_label+1+t:i*num_samples_per_label,:);
end
%Xremainder = X;
%yremainder = y;

pred = predictOneVsAll(all_theta, Xremainder);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == yremainder)) * 100);

