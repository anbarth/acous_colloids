% populate all the data fields with the columns:
% time (s); force (N); stroke (mm)
big_bones.sample_1.data = read_shimadzu_csv("PU_large_1.csv");
big_bones.sample_2.data = read_shimadzu_csv("PU_large_2.csv");
big_bones.sample_3.data = read_shimadzu_csv("PU_large_3.csv");
big_bones.sample_4.data = read_shimadzu_csv("PU_large_4_oil.csv");

small_bones.sample_1.data = read_shimadzu_csv("PU_small_1.csv");
small_bones.sample_2.data = read_shimadzu_csv("PU_small_2.csv");
small_bones.sample_3.data = read_shimadzu_csv("PU_small_3.csv");
small_bones.sample_4.data = read_shimadzu_csv("PU_small_4.csv");
small_bones.sample_5.data = read_shimadzu_csv("PU_small_5.csv");

% dimensions: x-section width, x-section height, bone length 
% (mm)
in_to_mm = 25.4;
big_bones.sample_1.dims = [0.237 0.119 1.45]*in_to_mm;
big_bones.sample_2.dims = [0.237 0.110 1.45]*in_to_mm;
big_bones.sample_3.dims = [0.236 0.105 1.45]*in_to_mm;
big_bones.sample_4.dims = [0.245 0.136 1.45]*in_to_mm;

small_bones.sample_1.dims = [0.249 0.157 1.5]*in_to_mm;
small_bones.sample_2.dims = [0.232 0.159 1.5]*in_to_mm;
small_bones.sample_3.dims = [0.232 0.136 1.5]*in_to_mm;
small_bones.sample_4.dims = [0.232 0.128 1.5]*in_to_mm;
small_bones.sample_5.dims = [0.232 0.115 1.5]*in_to_mm;