clear

%Small Sample
    X = linspace(-pi,pi,1000);
    Y = linspace(-pi,pi,1000);
    [X_grid,Y_grid]=meshgrid(X,Y);
    Z = X_grid.^2+Y_grid.^2+2*sin(X_grid.*Y_grid);
    
    data_large = [reshape(X_grid,[],1),reshape(Y_grid,[],1),reshape(Z,[],1)];    
    data_small = data_large([1:10:1000],:)
    
    %Define a network
        %VERY small network (two logits), approx MSE 13
        counter = 0;
        rng(1)
        for netsize = [1,2,3,4,5,10,20]
            %Shallow, small sample
            tic
            counter = counter+1;
            net = fitnet(netsize);
            net = train(net,data_small(:,1:2)',data_small(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [0,netsize,0,0,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]

            %Shallow, large sample
            tic
            counter = counter+1;
            net = fitnet(netsize);
            net = train(net,data_small(:,1:2)',data_small(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [1,netsize,0,0,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]

            %Middle, small sample
            tic
            counter = counter+1;
            net = fitnet([netsize,netsize]);
            net = train(net,data_small(:,1:2)',data_small(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [0,netsize,netsize,0,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]

            %Middle, large sample
            tic
            counter = counter+1;
            net = fitnet([netsize,netsize]);
            net = train(net,data_large(:,1:2)',data_large(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [1,netsize,netsize,0,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]

            %Deep, small sample
            tic
            counter = counter+1;
            net = fitnet([netsize,netsize,netsize]);
            net = train(net,data_small(:,1:2)',data_small(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [0,netsize,netsize,netsize,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]

            %Deep, large sample
            tic
            counter = counter+1;
            net = fitnet([netsize,netsize,netsize]);
            net = train(net,data_large(:,1:2)',data_large(:,3)','UseParallel','yes');
            error=reshape((net(data_large(:,1:2)')-data_large(:,3)')',size(X_grid));
            tabin(counter,:) = [1,netsize,netsize,netsize,min(error,[],'all'),max(error,[],'all'),std(error,0,'all'),mean(abs(error),'all'),toc]
        end
