1. ʹ�õ�caffemodel��Ԥѵ���õ�model����train���̾��ǶԴ�model����fine-tune��ʹ��model�ʺϱ�������


2. ѵ��֮ǰ����Ҫ��ͼƬת��Ϊlmdb��ʽ��ʹ�ó���creat_set�����岽�����£�

��1�����ѵ��ͼƬ���㣬��Ҫ�����ݽ������䣬ʹ�ó��� data augmentation

��2����ͼƬ�����Ƽӱ�ǩ�󱣴���txt�ļ��У�ʹ��file list

��3��ʹ��creat_set��ͼƬת��Ϊlmdb��ʽ��ע��groundtruth���ɫͼ��Ĳ��


3. ʹ��train_cnn����ѵ��

��1����Ҫ���ĵ����ݰ�����
train_rgbd_so.sh��caffe��·����ѵ���׶�.prototxt�ļ���·��������caffemodel��λ��
SO_rgbd_global_vgg_solver.prototxt��ѵ�����̲��������ļ�����Ҫ�����ѧϰ�ʣ���������������˽�
SO_rgbd_global_vgg_train_val.prototxt��ѵ���������ã�����ṹ˵��
    ��Ҫ���õ�·��������ԭͼ���groundtruth��lmdb��ʽ
    ����ṹ��������������и���Ľṹ���ɸ�����Ҫ�޸�