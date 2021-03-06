% Starter code prepared by James Hays for Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_spatial_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

load('vocab.mat')
global vocab_g;
vocab_g = vocab;
global vocab_size;
vocab_size = size(vocab, 1);

image_feats = zeros(numel(image_paths), vocab_size);

global step_size;
step_size = 6;
global bin_size;
bin_size = 8;

for i = 1:numel(image_paths)     
    fprintf('\b\b\b\b\b\b%6.0f',i);
    im_orig = imread(char(image_paths(i)));
    im_orig = im2single(im_orig);
    
    %level 0
    [locations, sift_feat] = vl_dsift(im_orig, 'step', step_size, 'size', bin_size, 'fast');        
    all_dist = vl_alldist2(double(sift_feat), vocab');
    [Y,I] = min(all_dist,[],2);
    [N, edges] = histcounts(I,1:vocab_size+1);
    
    %Normalization
    mean_row = mean(N);
    N = N - mean_row;
    var_row = var(N);
    N = N ./ sqrt(var_row);    
    
    image_feats(i,:) = image_feats(i,:) + N;
    
    %level 1
    div_1 = ceil(size(im_orig,1)/2);
    div_2 = ceil(size(im_orig,2)/2);
    
    fun = @(block_struct) func_bp(block_struct.data);
    N = blockproc(im_orig, [div_1, div_2], fun);
    N = N./(1/4);
    
    N = (reshape(N',[],4))';
    
    %Normalization
    mean_row = mean(N,2);
    N = N - repmat(mean_row, 1, size(N,2));
    var_row = var(N,0,2);
    N = N ./ repmat(sqrt(var_row),1,size(N,2));

    image_feats(i,:) = image_feats(i,:) + sum(N,1);
    
    % level 2
    div_1 = ceil(size(im_orig,1)/4);
    div_2 = ceil(size(im_orig,2)/4);
    
    fun = @(block_struct) func_bp(block_struct.data);
    N = blockproc(im_orig, [div_1, div_2], fun);
    N = N./(1/16);
    
    N = (reshape(N',[],16))';
    
    %Normalization
    mean_row = mean(N,2);
    N = N - repmat(mean_row, 1, size(N,2));
    var_row = var(N,0,2);
    N = N ./ repmat(sqrt(var_row),1,size(N,2));

    image_feats(i,:) = image_feats(i,:) + sum(N,1);
       
%     im_size1 = im_orig(1:div_1,1:div_2);
%     im_size2 = im_orig(1:div1,div_2+1:end);
%     im_size3 = im_orig(div_1+1:end,1:div_2);    
%     im_size4 = im_orig(div_1+1:end,div_2+1:end);
    
end


%% Normalization
mean_row = mean(image_feats,2);
image_feats = image_feats - repmat(mean_row, 1, vocab_size);
var_row = var(image_feats,0,2);
image_feats = image_feats ./ repmat(sqrt(var_row),1,vocab_size);

end

%% Useful Function
%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.

Or:

For speed, you might want to play with a KD-tree algorithm (we found it
reduced computation time modestly.) vl_feat includes functions for building
and using KD-trees.
 http://www.vlfeat.org/matlab/vl_kdtreebuild.html

%}

function N = func_bp(im_orig)
global step_size;
global bin_size;
global vocab_g;
global vocab_size;


[locations, sift_feat] = vl_dsift(im_orig, 'step', step_size, 'size', bin_size, 'fast');        
all_dist = vl_alldist2(double(sift_feat), vocab_g');
[Y,I] = min(all_dist,[],2);
[N, edges] = histcounts(I,1:vocab_size+1);

end





