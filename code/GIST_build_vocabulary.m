% Starter code prepared by James Hays for Computer Vision

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function vocab = build_vocabulary( image_paths, vocab_size )
% The inputs are 'image_paths', a N x 1 cell array of image paths, and
% 'vocab_size' the size of the vocabulary.

% The output 'vocab' should be vocab_size x 128. Each row is a cluster
% centroid / visual word.
step_size = 20;
bin_size = 8;
all_sift_feat = [];
all_gist_feat = [];

for i = 1:numel(image_paths)
    fprintf('\b\b\b\b\b\b%6.0f',i);
    im_orig = imread(char(image_paths(i)));
    im_orig = im2single(im_orig);
    
    % SIFT
    %[locations, sift_feat]= vl_dsift(im_orig, 'step', step_size, 'size', bin_size);
    %all_sift_feat = [all_sift_feat sift_feat];
    
    % GIST Parameters:
    clear param
    param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
    param.numberBlocks = 2;
    param.fc_prefilt = 4;

    % Computing gist:
    [gist, param] = LMgist(im_orig, '', param);
    all_gist_feat = [all_gist_feat gist'];
end

%[centres, assignments] = vl_kmeans(double(all_sift_feat), vocab_size);
[centres, assignments] = vl_kmeans(double(all_gist_feat), vocab_size);
vocab = centres';


%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be thrown away here
  (but possibly used for extra credit in get_bags_of_sifts if you're making
  a "spatial pyramid").
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

[centers, assignments] = vl_kmeans(X, K)
 http://www.vlfeat.org/matlab/vl_kmeans.html
  X is a d x M matrix of sampled SIFT features, where M is the number of
   features sampled. M should be pretty large! Make sure matrix is of type
   single to be safe. E.g. single(matrix).
  K is the number of clusters desired (vocab_size)
  centers is a d x K matrix of cluster centroids. This is your vocabulary.
   You can disregard 'assignments'.

  Matlab has a built in kmeans function, see 'help kmeans', but it is
  slower.
%}

% Load images from the training set. To save computation time, you don't
% necessarily need to sample from all images, although it would be better
% to do so. You can randomly sample the descriptors from each image to save
% memory and speed up the clustering. Or you can simply call vl_dsift with
% a large step size here, but a smaller step size in get_bags_of_sifts.m. 

% For each loaded image, get some SIFT features. You don't have to get as
% many SIFT features as you will in get_bags_of_sift.m, because you're only
% trying to get a representative sample here.

% Once you have tens of thousands of SIFT features from many training
% images, cluster them with kmeans. The resulting centroids are now your
% visual word vocabulary.






