function [J, grad] = lrCostFunction(theta, X, y, Y, lambda)
%LRCOSTFUNCTION Compute cost and gradient for logistic regression with 
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, Y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Hint: The computation of the cost function and gradients can be
%       efficiently vectorized. For example, consider the computation
%
%           sigmoid(X * theta)
%
%       Each row of the resulting matrix will contain the value of the
%       prediction for that example. You can make use of this to vectorize
%       the cost function and gradient computations. 
%
% Hint: When computing the gradient of the regularized cost function, 
%       there're many possible vectorized solutions, but one solution
%       looks like:
%           grad = (unregularized gradient for logistic regression)
%           temp = theta; 
%           temp(1) = 0;   % because we don't add anything for j = 0  
%           grad = grad + YOUR_CODE_HERE (using the temp variable)
%
n_1 = columns(X);
num_labels = rows(theta)/n_1;

theta_n_1Xnum_labels = reshape(theta, n_1, num_labels); % n+1 X num_labels
z = X*theta_n_1Xnum_labels; % m X num_labels
h = exp(z); % m X num_labels
den = sum(h, 2); % sum along second (column) dimension. result m X 1.
h = h./den; % broadcasting happens here. result m X num_labels
h1 = zeros(m, 1);
for j = 1:m
    h1(j) = h(j, y(j)); % select h(:,j) where y(i) == j
end
J = (-1/m)*sum(log(h1)) + (lambda/2/m)*(theta'*theta);
grad = X'*(h - Y)/m + (lambda/m)*theta_n_1Xnum_labels;







% =============================================================

grad = grad(:);

end
