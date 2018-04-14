
Description:
=============
This module implements a fast version of the popular Non-Local Means filter for image denoising. This algorithm filters each pixel as a weighted average of its neighbors in a large vicinity. The weights are computed based on the similarity of each neighbor with the voxel to be denoised.

In the original formulation a patch with a certain radius is centered in each of the voxels, and the Mean Squared Error between each pair of corresponding voxels is computed. In this implementation, only the mean value and gradient components are compared. This, together with an efficient memory management, can attain a speed-up of nearly 20x. Besides, the filtering is more accurate than the original with poor SNR.

This code is intended for its use with MRI (or any other Rician-distributed modality): the second order moment is estimated, then we subtract twice the squared power of noise, and finally we take the square root of the result to remove the Rician bias.

The original implementation of the NLM filter may be found in:

   A. Buades, B. Coll, J. Morel, "A review of image denoising algorithms, with a new one", Multiscale Modelling and Simulation 4(2): 490-530. 2005.

The correction of the Rician bias is described in the following reference (among others):

   S. Aja-Fernandez, K. Krissian, "An unbiased Non-Local Means scheme for DWI filtering", in: Proceedings of the MICCAI Workshop on Computational Diffusion MRI, 2008, pp. 277-284.

The whole description of this version may be found in the following paper (please, cite it if you are willing to use this software):

   A. Tristan-Vega, V. Garcia Perez, S. Aja-Fenandez, and C.-F. Westin, "Efficient and Robust Nonlocal Means Denoising of MR Data Based on Salient Features Matching", Computer Methods and Programs in Biomedicine. (Accepted for publication) 2011.

A copy of svn2git https://www.nitrc.org/svn/unlmeans --rootistrunk for testing

