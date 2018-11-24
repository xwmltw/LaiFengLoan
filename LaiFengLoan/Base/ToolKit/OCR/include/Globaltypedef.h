#ifndef GLOBAL_TYPEDEF
#define GLOBAL_TYPEDEF

#include "stdio.h"
#include "string.h"
#include "stdlib.h"


#ifndef _API_EXPORTS
#define _API_EXPORTS
#endif

/* ��ȡ֤������*/
typedef enum
{
	TUNCERTAIN			= 0x00,   /*δ֪*/
	TIDCARD2			= 0x11,   /*����֤*/
	TIDCARDBACK			= 0x14,   /*����֤����*/
	TIDBANK				= 0x15,   /*���п�*/
	TIDLPR				= 0x16,   /*����*/
	TIDJSZCARD			= 0x17,   /*����*/
	TIDXSZCARD			= 0x18,   /*��ʻ֤*/
	TIDTICKET			= 0x19,   /*��Ʊ*/
	TIDSSCCARD			= 0x20,   /*�籣��*/
	TIDPASSPORT			= 0x21,	  /*����*/
	TIDHOSPITALLIST		= 0x22,	  /*ҽԺ�����嵥*/
	TIDBIZLIC			= 0x23,	  /*Ӫҵִ��*/
	TIDINVOICE		=	0x24, /*��ֵ˰��Ʊ*/
	TIDDOCUMENT		=	0x25, /*ͨ���ĵ�*/
	TIDLASTFLG		=	0x26, /*������־*/
/*--TURI_NEWENGINE_STEP_XXX_CFG--*//*����ɾ�����޸ĸñ�ǩ*/

} TCARD_TYPE;

#define	pNULL				((void *)0)
#define LENTH_VERSION_MAX	64   // �汾�ų���
#define LENTH_512			512


typedef unsigned char	Gbyte; /**<  �޷����ַ��� 0 ~ 255(0xff)*/
typedef unsigned short	UShort;/**<  �޷��Ŷ�����0 ~ 65535(0xffff)*/
typedef unsigned short	Ushort;/**<  �޷��Ŷ�����0 ~ 65535(0xffff)*/
typedef short			Gshort; /**<  ������ -32768 ~ 32767*/
typedef int				Gint;   /**<  ���� 2147483647~-2147483648*/
typedef long			Glong;  /**<  ������ -2147483648��2147483647*/
typedef unsigned long	ULong;  /**< �޷��ų����� 0 ~ 4294967295*/
typedef unsigned int	UInt;  /**<  �޷������� 0 ~ 4294967295*/
/*typedef unsigned int	size_t;*/

/*�����*/
typedef struct tagImgROI
{
	Gint   xOffset;  /*xλ��*/
	Gint   yOffset;  /*yλ��*/
	Gint   width;    /*���*/
	Gint   height;	/*�߶�*/
}
ImgROI;



/*����ѡ��*/
typedef enum enumParam
{
	T_ONLY_CARD_NUM			  = 0x0001,/* �����Ƿ�ֻʶ�𿨺�*/
	T_SET_HEADIMG			  = 0x0002,/* �����Ƿ�Ҫ��ȡ��ͷ����Ϣ*/
	/*T_SET_PRINTFLOG			  = 0x0003,/ * �����Ƿ񱣴�log��Ϣ* �����ѷ���/*/
	T_SET_LOGPATH			  = 0x0004,/* ���ñ���log�����ļ�λ��*/
	/*T_SET_OPENORCLOSE_LOGPATH = 0x0005,/ * �򿪹رձ���log�ļ�����* �����ѷ���/*/
	T_SET_HEADIMGBUFMODE      = 0x0006,/* ������ͷ��ģʽ 0= ԭʼ��ʽ(����android iosֱ�Ӽ���)   1=BASE64������ʽ(����sdk���紫��)*/
	T_SET_NDCORRECTION        = 0x0007,/* �����Ƿ���л��ν�������*/

	T_SET_RECMODE			  = 0x0008,/* ��������ʶ��ģʽ����֧�����֤�����п�*/
	T_SET_AREA_LEFT			  = 0x0009,/* ����ɨ��ģʽ��ʶ����������������꣬��֧�����֤�����п�*/
	T_SET_AREA_TOP			  = 0x0010,/* ����ɨ��ģʽ��ʶ���������򶥵����꣬��֧�����֤�����п�*/
	T_SET_AREA_WIDTH		  = 0x0011,/* ����ɨ��ģʽ��ʶ�����������ȣ���֧�����֤�����п�*/
	T_SET_AREA_HEIGHT		  = 0x0012,/* ����ɨ��ģʽ��ʶ����������߶ȣ���֧�����֤�����п�*/
	T_SET_ROTATE_180		  = 0x0015,

	T_SET_BANK_LINE_STREAM	  = 0x0013,/* �����Ƿ���ͼƬ���ķ�ʽ�������п�����*/

	T_SET_SSC_AREA_NAME 	  = 0x0014,/* �����籣��ʶ��ʡ��*/
}TPARAM;

/*���֤ͼ����*/
typedef enum
{
	IMG_DIRECT_UP		= 0,
	IMG_DIRECT_RIGHT	= 1,
	IMG_DIRECT_BOTTOM	= 2,
	IMG_DIRECT_LEFT		= 3,
}TDIRECT_TYPE;

/*������ɫ*/
typedef enum enumPlateColor
{
	BLUE_PLATE		= 1,/*��ɫ*/
	YELLOW_PLATE	= 2,/*��ɫ*/
	WHITE_PLATE		= 4,/*��ɫ*/
	BLACK_PLATE		= 8 /*��ɫ*/
}LPR_COLOR;

/*���Ʋ㼶*/
typedef enum enumPlateLayer
{
	SIG_LAYER		=	1,/*����*/
	MUL_LAYER		=	2 /*���*/
}LPR_LAYER;
/* ��ȡ�ֶ�����*/
typedef enum
{
	//���֤
	NAME                = 0,/* ����*/
	SEX                 = 1,/* �Ա�*/
	FOLK                = 2,/* ����*/
	BIRTHDAY            = 3,/* ��������*/
	ADDRESS             = 4,/* ��ַ*/
	NUM                 = 5,/* ����*/
	ISSUE               = 6,/* ǩ������*/
	PERIOD              = 7,/* ��Ч����*/
	LPR_NUM				= 8,/* ���ƺ���*/
	LPR_PLATECOLOR		= 9,/* ������ɫ*/
	
	//��ʻ֤
	DP_PLATENO			= 10,/* ���ƺ���*/
	DP_TYPE				= 11,/* ��������*/
	DP_OWNER			= 12,/* ������*/
	DP_ADDRESS			= 13,/* סַ*/
	DP_USECHARACTER		= 14,/* ʹ������*/
	DP_MODEL			= 15,/* Ʒ�ƺ���*/
	DP_VIN				= 16,/* ����ʶ�����*/
	DP_ENGINENO			= 17,/* ����������*/
	DP_REGISTER_DATE	= 18,/* ע������*/
	DP_ISSUE_DATE		= 19,/* ��֤����*/

	//��ʻ֤
	DL_NUM				= 20,/* ����*/
	DL_NAME				= 21,/* ����*/
	DL_SEX				= 22,/* �Ա�*/
	DL_COUNTRY			= 23,/* ����*/
	DL_ADDRESS			= 24,/* ��ַ*/
	DL_BIRTHDAY			= 25,/* ��������*/
	DL_ISSUE_DATE		= 26,/*������֤����*/
	DL_CLASS			= 27,/*׼�ݳ���*/
	DL_VALIDFROM		= 28,/*��Ч��ʼ����*/
	DL_VALIDFOR			= 29,/* ��Ч����*/
	
	//��Ʊ
	TIC_START			= 30,/* ��ʼվ*/
	TIC_NUM				= 31,/* ����*/
	TIC_END				= 32,/* �յ�վ*/
	TIC_TIME			= 33,/* ����ʱ��*/
	TIC_SEAT			= 34,/* ��λ��*/
	TIC_NAME			= 35,/* ����*/
	TIC_PRICE			= 61,/* �۸�*/
	TIC_SEATCLASS		= 62,/* ��λ����*/
	TIC_CARDNUM			= 63,/* ���֤����*/

	/*���п��ֶ�*/
	TBANK_NUM			= 36,//��ȡ���п���
	TBANK_NAME			= 37,//��ȡ���п�������
	TBANK_ORGCODE		= 38,//��ȡ���л�������
	TBANK_CLASS			= 39,//��ȡ����
	TBANK_CARD_NAME		= 40,//��ȡ����
	TBANK_NUM_REGION	= 41,//��ȡ���п���������
	TBANK_NUM_CHECKSTATUS	= 42,//��ȡ���п���У��״̬����״̬��ǽ��ڷ�ɨ��ʶ��ģʽ����Ч��
	TBANK_IMG_STREAM		= 43, // ���п���������ͼ�ֽ���
	TBANK_LENTH_IMGSTREAM	= 44, // ��������ͼƬ�ֽ�������

	/*�籣���ֶ�*/
	SSC_NAME			= 45,/*����*/
	SSC_NUM				= 46,/*���֤��*/
	SSC_SHORTNUM		= 47,/*����*/
	SSC_PERIOD			= 48,/*��Ч����*/
	SSC_BANKNUM			= 49,/*���п���*/

	/*�����ֶ�*/
	PAS_PASNO			= 50,/*���պ�*/
	PAS_NAME			= 51,/*����*/
	PAS_SEX				= 52,/*�Ա�*/
	PAS_IDCARDNUM		= 53,/*���֤����*/
	PAS_BIRTH			= 54,/*����*/
	PAS_PLACE_BIRTH		= 55,/*������ַ*/
	PAS_DATE_ISSUE		= 56,/*ǩ������*/
	PAS_DATE_EXPIRY		= 57,/*��Ч����*/
	PAS_PLACE_ISSUE		= 58,/*ǩ����ַ*/
	PAS_NATION_NAME		= 59,/*�����������ල��*/
	PAS_MACHINE_RCODE	= 60,/*���պ�+��������+���մ��루YYMMDD��+�Ա�M/F��+������Ч�ڣ�YYMMDD��+У���� �ල��*/

	HSL_NAME			= 64,
	HSL_NUM				= 65,
	HSL_DATE			= 66,
	HSL_FIGURE			= 67,
	HSL_FIGURE_SUM		= 68,

	BLIC_CODE			= 72,/* ͳһ������ô���*/ 
	BLIC_NAME			= 73, /*����*/
	BLIC_TYPE			= 74, /*����*/
	BLIC_ADDR			= 75, /*ס��*/
	BLIC_PERSON			= 76, /*����������*/
	BLIC_CAPTIAL		= 77, /*ע���ʱ�*/
	BLIC_DATE			= 78, /*��������*/
	BLIC_PERIOD			= 79, /*Ӫҵ����*/
	BLIC_ISSUE			= 80, /*��֤����*/

	INV_CODE			= 84, /*��Ʊ����*/
	INV_NUM				= 85, /*��Ʊ����*/
	INV_DATE			= 86, /*��Ʊ����*/
	INV_BUY				= 87, /*������ҵ����*/
	INV_BUYCODE			= 88, /*������˰��*/
	INV_SALE			= 89, /*������ҵ����*/
	INV_SALECODE		= 90, /*������˰��*/
	INV_PRODUCT			= 91, /*�����Ӧ˰��������*/
	INV_PRICE_TAX		= 92, /*��˰�ϼ�*/
	INV_PRICE			= 93, /*�ϼƽ��*/
	INV_TAX				= 94, /*�ϼ�˰��*/
	INV_MARK			= 95, /*��ע*/
	INV_TAXRATE			= 96, /*˰��*/

	DOC_TEXT			= 100, /*�ĵ��ı�*/

	TMAX				= 104, /*���ֵ*/
/*--TURI_NEWENGINE_STEP_XXX_DECLARE--*//*����ɾ�����޸ĸñ�ǩ*/
}TFIELDID;

/*��ȡ�����λ��*/
typedef enum
{
	POS_LEFT_TOP		= 0,
	POS_RIGHT_TOP		= 1,
	POS_LEFT_BOTTOM		= 2,
	POS_RIGHT_BOTTOM	= 3,
}POINT_POS;

/**��ȡ��Ŀ������Ϣ�����������**/
typedef struct
{
	/**input*/
	POINT_POS	pos;	/*��Ҫ��ȡ�ĸ������λ��*/
	TFIELDID	field;	/*��ĿID*/

	/**Output*/
	Gint	posPointX;
	Gint	posPointY;
}PosiTion;

/*�ص���������*/
typedef int (*f_progress)(char *p);
/*�ص�����*/
extern f_progress SendToMainMsg;

///////////////////////////////////////////////////////////////////////////////////////////
/*���п�ʶ���������ṹ*/
#define MAX_LENTH_CARDNUM		32
#define MAX_LENTH_VERSIONINFO	LENTH_VERSION_MAX
#define MAX_LENTH_BANKNAME		64
#define MAX_LENTH_CARDCLASS		16

/*���п�ʶ��ģʽ*/
typedef enum
{
	TBANK_MODE_SCAN		   = 0,//(Ĭ��ģʽ)
	TBANK_MODE_OTHER	   = 1,
}TBANK_REC_MODE;

typedef enum
{
	TIDC_NORMAL_MODE	   = 0,/*��ͳ��������ģʽ(Ĭ��ģʽ)*/
	TIDC_SCAN_MODE		   = 1,/*ɨ��ʶ��ģʽ*/
}TIDC_REC_MODE;

/*���п���������ͼƬ�Ƿ���JPG������ʽת��*/
typedef enum
{
	NONNEED_EXTRA_LINE_IMAGE_STREAM	=	0,
	NEED_EXTRA_LINE_IMAGE_STREAM	=	1,
}TBANK_EXPORT_STREAM;

/*���п���ʶ�����Ƿ�����LUTIУ��ģʽ(��У��ģʽ���ڷ�ɨ��ģʽ����Ч)*/
typedef enum
{
	TBANK_STATUS_FAIL	  = 0,
	TBANK_STATUS_CHECK	  = 1,
}TBANK_CARDNUM_STATUS;

/*��ȡ���п���Ӧ��Ŀ��Ϣ*/
typedef enum
{
	T_GET_BANK_NUM			= 0x01,//��ȡ���п���
	T_GET_BANK_NAME			= 0x02,//��ȡ���п�������
	T_GET_BANK_ORGCODE		= 0x03,//��ȡ���л�������
	T_GET_BANK_CLASS		= 0x04,//��ȡ����
	T_GET_CARD_NAME			= 0x05,//��ȡ����
	T_GET_NUM_REGION		= 0x06,//��ȡ���п���������
	T_GET_NUM_CHECKSTATUS	= 0x07,//��ȡ���п���У��״̬����״̬��ǽ��ڷ�ɨ��ʶ��ģʽ����Ч��
	T_GET_IMAGE_STREAM		= 0x08,
	T_GET_LENTH_IMGSTREAM	= 0x09,
}TGETBANKINFOID;

typedef enum
{
	ARE_FUJIAN  = 0x01,/*����*/
	ARE_SHANGHAI= 0x01,/*�Ϻ�*/
}SSCAREANAME;
#endif