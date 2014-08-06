im = imread('block1.jpg');
figure; imshow(im);
block_rows = 16;
block_cols = 16;

im_rows = size(im,1);
im_cols = size(im,2);

index_br = [1:block_rows:im_rows im_rows];
index_bc = [1:block_cols:im_cols im_cols];

for i = 1:numel(index_br)-1
    im(index_br(i),:,1) = 255;
    im(index_br(i),:,2) = 0;
    im(index_br(i),:,3) = 0;
    im(index_br(i+1),:,1) = 255;
    im(index_br(i+1),:,2) = 0;
    im(index_br(i+1),:,3) = 0;
    for j = 1:numel(index_bc)-1
        im(index_br(i):index_br(i+1),index_bc(j),1) = 255;
        im(index_br(i):index_br(i+1),index_bc(j),2) = 0;
        im(index_br(i):index_br(i+1),index_bc(j),3) = 0;
        im(index_br(i):index_br(i+1),index_bc(j+1),1) = 255;
        im(index_br(i):index_br(i+1),index_bc(j+1),2) = 0;
        im(index_br(i):index_br(i+1),index_bc(j+1),3) = 0;
    end
end
figure; imshow(im);