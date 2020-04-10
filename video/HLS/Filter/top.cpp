
#include "top.h"

void Filter (AXI_STREAM& INPUT_STREAM, AXI_STREAM& OUTPUT_STREAM) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=INPUT_STREAM
#pragma HLS INTERFACE axis port=OUTPUT_STREAM

  hls::Mat<HEIGHT, WIDTH, HLS_8UC3> img_0(HEIGHT, WIDTH);
  hls::Mat<HEIGHT, WIDTH, HLS_8UC3> img_1(HEIGHT, WIDTH);

  #pragma HLS dataflow
	
  hls::AXIvideo2Mat(INPUT_STREAM, img_0);

//// inicio del procesado de video ///////////////////////////////////

  for(int row = 0; row <  HEIGHT; row++) {
  #pragma HLS loop_flatten off
    for(int col = 0; col <  WIDTH; col++) {
    #pragma HLS pipeline II=1

      RGB_PIXEL p;
      RGB_PIXEL result;

      img_0 >> p;  // lectura del stream de entrada
	
      result.val[0] = p.val[0];
      result.val[1] = p.val[1];
      result.val[2] = p.val[2];

      if ((row > 119) and (row < 360) and (col > 159) and (col < 480)) {
        if(result.val[0] < 30 && result.val[1] < 30 && result.val[2] < 30){
          result.val[0] = 0;
          result.val[1] = 255;
          result.val[2] = 0;
        }
      }

      img_1 << result;   // escritura en el stream de salida
			
     } // col loop
  } // row loop
	
//// fin del procesado de video //////////////////////////////////////

  hls::Mat2AXIvideo(img_1, OUTPUT_STREAM);
}
