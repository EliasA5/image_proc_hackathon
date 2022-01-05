function [output_vector, output_edge] = dig_edge_detect(Diamond)
    Diamond_gr = rgb2gray(Diamond);
    Diamond_BW = imbinarize(Diamond_gr);
    output_vector = zeros(1,4, 'uint16');
    [B, ~, N] = bwboundaries(Diamond_BW);
    output_edge = zeros(size(Diamond_BW), 'logical');
    %======= Extracting the edges of the diamond matrix ========
    if(length(B) > N)
        boundary = B{end};
        xc = boundary(:,2);
        yc = boundary(:,1);
        idx = sub2ind(size(Diamond_BW), yc, xc);
        output_edge(idx) = 1;
        %========== create vector output ============
        output_vector(1) = min(xc); % column
        output_vector(2) = min(yc); % row
        output_vector(3) = max(xc) - min(xc); % width
        output_vector(4) =  max(yc) - min(yc); % height
        if(output_vector(3) == 0)
            output_vector(3) = 1;
        end
        if(output_vector(4) == 0)
            output_vector(4) = 1;
        end
    end
end
    
    
    
    
    