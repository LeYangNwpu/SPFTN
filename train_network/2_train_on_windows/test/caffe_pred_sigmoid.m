clear
clc

if exist('E:/NianLiu/Deep_Learning_codes/caffe/caffe-master/matlab/+caffe', 'dir')
  addpath('E:/NianLiu/Deep_Learning_codes/caffe/caffe-master/matlab/');
else
  error('Please run this demo from caffe/matlab/demo');
end

% Set caffe mode
if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 0;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end
use_gpu=0;

%����ͼƬ��·��
imgPath='H:\mcc\image\JPEGImages\soldier\';
imgFiles = dir([imgPath  '*.png']);
imgrgb = imread([imgPath,imgFiles(1).name]);
[imgrows,imgcols,~] = size(imgrgb);

%% singleview2
net_model = 'H:\mcc\code\train_cnn\saliency\deploy.prototxt';
net_weights = 'H:\mcc\code\train_cnn\SaliencyModle.caffemodel';
saveRootPathimg = 'H:\mcc\model\00-SaliencyResult\soldier\image\';
saveRootPathmat = 'H:\mcc\model\00-SaliencyResult\soldier\mat\';

phase = 'test'; % run with phase test (so that dropout isn't applied)
net = caffe.Net(net_model, net_weights, phase);
imgNum=length(imgFiles);
mean_rgb =[103.939, 116.779 ,123.68];

batch_size=1;
CROPPED_DIM=224;
image_rgb=zeros(CROPPED_DIM, CROPPED_DIM, 3, batch_size, 'single');
for j=1:(imgNum/batch_size)
        for   i= ((j-1)*batch_size+1):j*batch_size
                    rgb=imread([imgPath  imgFiles(i).name]);  
                    rgb= prepare_image(rgb,mean_rgb);
                    k= mod(i,batch_size);
                    if k==0
                        k=batch_size;
                    end
                    image_rgb(:,:,:,k)=imresize(rgb,[CROPPED_DIM,CROPPED_DIM],'bilinear');
        end
        image{1}=image_rgb;    
        prescores=net.forward(image);
        scores = prescores{1};
        
        for ii=1:batch_size
            samp=scores(:,:,:,ii);
            salmap=permute(samp,[2,1]);
            imgname=imgFiles((j-1)*batch_size+ii).name;
            imgname=imgname(1:length(imgname)-4);
            save([saveRootPathmat,imgname,'.mat'],'salmap');            
            %��Ҫ��ͼƬ���ԭ�ߴ�
            salmap=imresize(salmap,[imgrows,imgcols],'bilinear');  
            salmap=uint8(255*salmap);
            imwrite(salmap,[saveRootPathimg imgFiles((j-1)*batch_size+ii).name]);
        end 
end

