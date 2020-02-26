function [StatJB] = JarqueBera(DataSet)
%Function performing the Jarque and Bera normality test.
%The level of confidence is set a 5%. 

%   First, the function computes the sample Kurtosis and Skewness of the
%   dataset.
Kurt = kurtosis(DataSet); 
Skew = skewness(DataSet);
k = size(DataSet,2);

% Then the function computes the test's statistic.

StatJB = zeros(1,k);%Empty matrice to store test's statistic 

for i = 1:k %Loop going over each asset class
StatJB(1,i) = length(DataSet)/6 * (Skew(i)^2 + ((Kurt(i)-3)^2)/4); %Formula of the test
end
 
end

