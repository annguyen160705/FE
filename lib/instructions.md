- ~/.volare	Thư mục chứa các PDK đã cài bằng Volare
- -name	Tìm file hoặc thư mục đúng với tên được chỉ định
- sky130_fd_sc_hd__tt_025C_1v80.lib	Tên thư viện Liberty cần tìm
- -print	In đường dẫn file tìm thấy
- -quit	Dừng tìm kiếm ngay khi gặp kết quả đầu tiên

1. Tìm thư viện TT (Typical-Typical)
find ~/.volare -name "sky130_fd_sc_hd__tt_025C_1v80.lib" -print -quit


2. Tìm thư viện SS (Slow-Slow)
find ~/.volare -name "sky130_fd_sc_hd__ss_100C_1v60.lib" -print -quit

3. Tìm thư viện FF (Fast-Fast)
find ~/.volare -name "sky130_fd_sc_hd__ff_n40C_1v95.lib" -print -quit

4. Tìm file Liberty
LIB_TT=$(find ~/.volare -name "sky130_fd_sc_hd__tt_025C_1v80.lib" -print -quit)

5. Lấy thư mục chứa file
LIB_DIR=$(dirname "$LIB_TT")

# Tạo liên kết.

6. Thư viện Typical dùng cho STA
ln -sfn "$LIB_DIR/sky130_fd_sc_hd__tt_025C_1v80.lib" lib/stdcells_tt.lib

7. Thư viện Slow dùng cho STA
ln -sfn "$LIB_DIR/sky130_fd_sc_hd__ss_100C_1v60.lib" lib/stdcells_ss.lib

8. Thư viện Fast dùng cho STA
ln -sfn "$LIB_DIR/sky130_fd_sc_hd__ff_n40C_1v95.lib" lib/stdcells_ff.lib

9. Thư viện TT mặc định dùng cho Yosys SYN
ln -sfn "$LIB_DIR/sky130_fd_sc_hd__tt_025C_1v80.lib" lib/stdcells.lib

