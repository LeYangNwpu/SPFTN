function iscons=IsConsistent(allpixnum,pro_f,pro_b)
%����ֵ���ж�����ͶӰ�Ľ���Ƿ�һ��
consth=0.2;

inconsistentpnum=sum(sum(xor(pro_f,pro_b)));
incpro=inconsistentpnum/allpixnum; 

if incpro<consth
    iscons=1;
else
    iscons=0;
end

end

