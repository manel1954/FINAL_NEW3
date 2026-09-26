/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.15.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QIcon>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QPushButton *pushButton_salir;
    QPushButton *pushButton_2;
    QPushButton *pushButton_Si;
    QPushButton *pushButton_No;
    QLabel *label_fecha_actualizacion;
    QLabel *label_fecha_actualizacion_mia;
    QLabel *label_ultima;
    QLabel *label_nueva;
    QLabel *label_actualizar;
    QLineEdit *lineEdit_puente;
    QLabel *label;
    QPushButton *pushButton_minimizar;
    QPushButton *pushButton_maximizar;
    QLabel *label_fechaDia;
    QLabel *label_fechaDia_2;
    QLabel *label_nadaQueActualizar;
    QLabel *label_fecha_actualizacion_mia_2;
    QLabel *label_fecha_actualizacion_mia_3;
    QTextEdit *textEdit;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(622, 490);
        QIcon icon;
        icon.addFile(QString::fromUtf8(":/ICONO_NOTA_VERSION.png"), QSize(), QIcon::Normal, QIcon::Off);
        MainWindow->setWindowIcon(icon);
        MainWindow->setStyleSheet(QString::fromUtf8("background-color: rgb(64, 66, 68);\n"
"border:3px solid #fff;\n"
""));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        pushButton_salir = new QPushButton(centralWidget);
        pushButton_salir->setObjectName(QString::fromUtf8("pushButton_salir"));
        pushButton_salir->setGeometry(QRect(20, 20, 21, 24));
        QFont font;
        font.setBold(true);
        font.setWeight(75);
        pushButton_salir->setFont(font);
        pushButton_salir->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_salir->setStyleSheet(QString::fromUtf8("background:transparent;\n"
"border:0px transparent;"));
        pushButton_2 = new QPushButton(centralWidget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(430, 720, 61, 21));
        pushButton_2->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_2->setFocusPolicy(Qt::NoFocus);
        pushButton_Si = new QPushButton(centralWidget);
        pushButton_Si->setObjectName(QString::fromUtf8("pushButton_Si"));
        pushButton_Si->setGeometry(QRect(470, 200, 51, 29));
        pushButton_Si->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_Si->setFocusPolicy(Qt::NoFocus);
        pushButton_Si->setStyleSheet(QString::fromUtf8("background-color: rgb(126, 130, 133);\n"
"border-radius:4px;\n"
"color:#fff;\n"
"border:0px transparent;\n"
"\n"
""));
        pushButton_No = new QPushButton(centralWidget);
        pushButton_No->setObjectName(QString::fromUtf8("pushButton_No"));
        pushButton_No->setGeometry(QRect(530, 200, 51, 29));
        pushButton_No->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_No->setFocusPolicy(Qt::NoFocus);
        pushButton_No->setStyleSheet(QString::fromUtf8("background-color: rgb(126, 130, 133);\n"
"border-radius:4px;\n"
"color:#fff;\n"
"border:0px transparent;\n"
""));
        label_fecha_actualizacion = new QLabel(centralWidget);
        label_fecha_actualizacion->setObjectName(QString::fromUtf8("label_fecha_actualizacion"));
        label_fecha_actualizacion->setGeometry(QRect(360, 490, 171, 29));
        label_fecha_actualizacion->setFont(font);
        label_fecha_actualizacion->setStyleSheet(QString::fromUtf8("border:1px solid #999;\n"
"border-radius:3px;\n"
"color: rgb(255, 255, 0);"));
        label_fecha_actualizacion->setAlignment(Qt::AlignCenter);
        label_fecha_actualizacion_mia = new QLabel(centralWidget);
        label_fecha_actualizacion_mia->setObjectName(QString::fromUtf8("label_fecha_actualizacion_mia"));
        label_fecha_actualizacion_mia->setGeometry(QRect(290, 150, 321, 29));
        label_fecha_actualizacion_mia->setFont(font);
        label_fecha_actualizacion_mia->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);\n"
"background:transparent;"));
        label_fecha_actualizacion_mia->setAlignment(Qt::AlignCenter);
        label_ultima = new QLabel(centralWidget);
        label_ultima->setObjectName(QString::fromUtf8("label_ultima"));
        label_ultima->setGeometry(QRect(370, 510, 181, 21));
        label_ultima->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);"));
        label_nueva = new QLabel(centralWidget);
        label_nueva->setObjectName(QString::fromUtf8("label_nueva"));
        label_nueva->setGeometry(QRect(80, 520, 181, 21));
        label_nueva->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);"));
        label_actualizar = new QLabel(centralWidget);
        label_actualizar->setObjectName(QString::fromUtf8("label_actualizar"));
        label_actualizar->setGeometry(QRect(160, 490, 311, 29));
        QFont font1;
        font1.setPointSize(17);
        label_actualizar->setFont(font1);
        label_actualizar->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);"));
        label_actualizar->setAlignment(Qt::AlignCenter);
        lineEdit_puente = new QLineEdit(centralWidget);
        lineEdit_puente->setObjectName(QString::fromUtf8("lineEdit_puente"));
        lineEdit_puente->setGeometry(QRect(280, 720, 113, 29));
        label = new QLabel(centralWidget);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(0, 0, 621, 261));
        label->setPixmap(QPixmap(QString::fromUtf8(":/Actualizar-imagen.jpg")));
        label->setScaledContents(true);
        pushButton_minimizar = new QPushButton(centralWidget);
        pushButton_minimizar->setObjectName(QString::fromUtf8("pushButton_minimizar"));
        pushButton_minimizar->setGeometry(QRect(120, 600, 36, 28));
        pushButton_minimizar->setFont(font);
        pushButton_minimizar->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_minimizar->setStyleSheet(QString::fromUtf8("background:transparent;\n"
"border:0px transparent;"));
        pushButton_maximizar = new QPushButton(centralWidget);
        pushButton_maximizar->setObjectName(QString::fromUtf8("pushButton_maximizar"));
        pushButton_maximizar->setGeometry(QRect(208, 600, 60, 31));
        QFont font2;
        font2.setBold(false);
        font2.setWeight(50);
        pushButton_maximizar->setFont(font2);
        pushButton_maximizar->setCursor(QCursor(Qt::PointingHandCursor));
        pushButton_maximizar->setStyleSheet(QString::fromUtf8("background-color: rgb(126, 130, 133);\n"
"border-radius:4px;\n"
"color:#fff;\n"
"border:0px transparent;"));
        label_fechaDia = new QLabel(centralWidget);
        label_fechaDia->setObjectName(QString::fromUtf8("label_fechaDia"));
        label_fechaDia->setGeometry(QRect(290, 70, 321, 29));
        label_fechaDia->setFont(font1);
        label_fechaDia->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);\n"
"background:transparent;"));
        label_fechaDia->setAlignment(Qt::AlignCenter);
        label_fechaDia_2 = new QLabel(centralWidget);
        label_fechaDia_2->setObjectName(QString::fromUtf8("label_fechaDia_2"));
        label_fechaDia_2->setGeometry(QRect(290, 19, 321, 29));
        label_fechaDia_2->setFont(font1);
        label_fechaDia_2->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);\n"
"background:transparent;"));
        label_fechaDia_2->setAlignment(Qt::AlignCenter);
        label_nadaQueActualizar = new QLabel(centralWidget);
        label_nadaQueActualizar->setObjectName(QString::fromUtf8("label_nadaQueActualizar"));
        label_nadaQueActualizar->setGeometry(QRect(230, 520, 321, 29));
        QFont font3;
        font3.setPointSize(14);
        font3.setBold(true);
        font3.setWeight(75);
        label_nadaQueActualizar->setFont(font3);
        label_nadaQueActualizar->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"color: rgb(255, 255, 255);\n"
"background:transparent;"));
        label_nadaQueActualizar->setAlignment(Qt::AlignCenter);
        label_fecha_actualizacion_mia_2 = new QLabel(centralWidget);
        label_fecha_actualizacion_mia_2->setObjectName(QString::fromUtf8("label_fecha_actualizacion_mia_2"));
        label_fecha_actualizacion_mia_2->setGeometry(QRect(290, 120, 321, 29));
        label_fecha_actualizacion_mia_2->setFont(font);
        label_fecha_actualizacion_mia_2->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"background-color: rgb(147, 151, 147);\n"
"background:transparent;\n"
"color:#999;"));
        label_fecha_actualizacion_mia_2->setAlignment(Qt::AlignCenter);
        label_fecha_actualizacion_mia_3 = new QLabel(centralWidget);
        label_fecha_actualizacion_mia_3->setObjectName(QString::fromUtf8("label_fecha_actualizacion_mia_3"));
        label_fecha_actualizacion_mia_3->setGeometry(QRect(348, 200, 111, 29));
        label_fecha_actualizacion_mia_3->setFont(font);
        label_fecha_actualizacion_mia_3->setStyleSheet(QString::fromUtf8("border:0px transparent;\n"
"background-color: rgb(147, 151, 147);\n"
"background:transparent;\n"
"color:#999;"));
        label_fecha_actualizacion_mia_3->setAlignment(Qt::AlignCenter);
        textEdit = new QTextEdit(centralWidget);
        textEdit->setObjectName(QString::fromUtf8("textEdit"));
        textEdit->setGeometry(QRect(13, 269, 601, 211));
        textEdit->setStyleSheet(QString::fromUtf8("color: rgb(145, 155, 157);"));
        MainWindow->setCentralWidget(centralWidget);
        pushButton_2->raise();
        label_nueva->raise();
        label_actualizar->raise();
        lineEdit_puente->raise();
        label->raise();
        label_fecha_actualizacion->raise();
        label_ultima->raise();
        label_fechaDia_2->raise();
        label_fechaDia->raise();
        pushButton_minimizar->raise();
        pushButton_maximizar->raise();
        label_nadaQueActualizar->raise();
        label_fecha_actualizacion_mia->raise();
        pushButton_Si->raise();
        pushButton_No->raise();
        label_fecha_actualizacion_mia_2->raise();
        label_fecha_actualizacion_mia_3->raise();
        textEdit->raise();
        pushButton_salir->raise();

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "Actualizaciones", nullptr));
#if QT_CONFIG(tooltip)
        pushButton_salir->setToolTip(QCoreApplication::translate("MainWindow", "<html><head/><body><p><span style=\" color:#ffff00;\">Cerrar</span></p></body></html>", nullptr));
#endif // QT_CONFIG(tooltip)
        pushButton_salir->setText(QString());
        pushButton_2->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_Si->setText(QCoreApplication::translate("MainWindow", "Si", nullptr));
        pushButton_No->setText(QCoreApplication::translate("MainWindow", "No", nullptr));
        label_fecha_actualizacion->setText(QCoreApplication::translate("MainWindow", "TextLabel", nullptr));
        label_fecha_actualizacion_mia->setText(QCoreApplication::translate("MainWindow", "TextLabel", nullptr));
        label_ultima->setText(QCoreApplication::translate("MainWindow", "Ultima actualizaci\303\263n", nullptr));
        label_nueva->setText(QCoreApplication::translate("MainWindow", "Nueva actualizaci\303\263n", nullptr));
        label_actualizar->setText(QCoreApplication::translate("MainWindow", "QUIERES ACTUALIZAR?", nullptr));
        label->setText(QString());
#if QT_CONFIG(tooltip)
        pushButton_minimizar->setToolTip(QCoreApplication::translate("MainWindow", "<html><head/><body><p><span style=\" color:#ffff00;\">Cierra las notas de las versiones</span></p></body></html>", nullptr));
#endif // QT_CONFIG(tooltip)
#if QT_CONFIG(whatsthis)
        pushButton_minimizar->setWhatsThis(QCoreApplication::translate("MainWindow", "<html><head/><body><p><span style=\" color:#ffff00;\">Minimizar</span></p></body></html>", nullptr));
#endif // QT_CONFIG(whatsthis)
        pushButton_minimizar->setText(QString());
#if QT_CONFIG(tooltip)
        pushButton_maximizar->setToolTip(QCoreApplication::translate("MainWindow", "<html><head/><body><p><span style=\" color:#ffff00;\">Abre las notas de las versiones</span></p></body></html>", nullptr));
#endif // QT_CONFIG(tooltip)
#if QT_CONFIG(whatsthis)
        pushButton_maximizar->setWhatsThis(QCoreApplication::translate("MainWindow", "<html><head/><body><p><span style=\" color:#ffff00;\">Minimizar</span></p></body></html>", nullptr));
#endif // QT_CONFIG(whatsthis)
        pushButton_maximizar->setText(QCoreApplication::translate("MainWindow", "Notas", nullptr));
        label_fechaDia->setText(QCoreApplication::translate("MainWindow", "Fecha dia", nullptr));
        label_fechaDia_2->setText(QCoreApplication::translate("MainWindow", "NUEVA ACTUALIZACI\303\223N", nullptr));
        label_nadaQueActualizar->setText(QCoreApplication::translate("MainWindow", "NO HAY ACTUALIZACIONES", nullptr));
        label_fecha_actualizacion_mia_2->setText(QCoreApplication::translate("MainWindow", "\303\232ltima Actualizaci\303\263n", nullptr));
        label_fecha_actualizacion_mia_3->setText(QCoreApplication::translate("MainWindow", "Actualizar:", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
