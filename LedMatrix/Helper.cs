using System;
using System.IO;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Processing.Transforms;

namespace LedMatrix.Helpers
{
	static class Helper
	{
		private static string FILE_LOCATION = "/dev/fb1";
		public static void WriteToFile(byte[] contentToWrite)
		{
			using (BinaryWriter writer = new BinaryWriter(File.Open(FILE_LOCATION, FileMode.Open)))
        	{
				for(int i = 0 ; i < contentToWrite.Length ; ++i)
				{
					writer.Seek(i,SeekOrigin.Begin);
					writer.Write(contentToWrite[i]);
				}
        	}
		}

		public static byte[] ConvertToByteArray(this short[] source)
		{
			byte[] arrayAsByte = new byte[source.Length * 2/*sizeof short*/];
			Buffer.BlockCopy(source, 0, arrayAsByte, 0, arrayAsByte.Length);
			return arrayAsByte;
		}

		public static Int16 CreatePixelFromRgb(byte r, byte g, byte b)
		{
			return (Int16) ( (r << 11 ) | (g << 5 ) | b);
		}

		public static void Rotate(this Image<Bgr565> original, int angle)
		{
			if(angle == 0 ) return;
			original.Mutate(x => x.Rotate(angle));
		}
	}
}