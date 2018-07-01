/*
 * Copyright (c) 2014, Denis Dzyubenko <denis@ddenis.info>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those
 * of the authors and should not be interpreted as representing official policies,
 * either expressed or implied, of the FreeBSD Project.
 */

#include <QApplication>
#include <QtWidgets>

#include "macpreferenceswindow.h"
#include "macstandardicon.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setAttribute(Qt::AA_UseHighDpiPixmaps);

    MacPreferencesWindow w;

    QIcon generalIcon = MacStandardIcon::icon(MacStandardIcon::PreferencesGeneral);
    QIcon quickLookIcon = MacStandardIcon::icon(MacStandardIcon::Info);

    QLabel blueWidget("Note: the window has fixed size");
    blueWidget.setAlignment(Qt::AlignCenter);
    blueWidget.setFixedSize(300, 150);

    QSize maxIconSize;
    QList<QIcon> icons;
    for (int i = 0; i < (int)MacStandardIcon::LastIcon; ++i) {
        MacStandardIcon::MacStandardIconType iconType = (MacStandardIcon::MacStandardIconType)i;
        QIcon icon = MacStandardIcon::icon(iconType);
        icons.append(icon);

        foreach (const QSize &size, icon.availableSizes()) {
            if (size.width() > maxIconSize.width())
                maxIconSize = size;
        }
    }

    QWidget iconsWidget;
    QVBoxLayout *layout = new QVBoxLayout(&iconsWidget);
    QListWidget iconListWidget;
    iconListWidget.setIconSize(maxIconSize);
    iconListWidget.setResizeMode(QListWidget::Adjust);
    iconListWidget.setViewMode(QListWidget::IconMode);
    for (int i = 0; i < (int)MacStandardIcon::LastIcon; ++i) {
        MacStandardIcon::MacStandardIconType iconType = (MacStandardIcon::MacStandardIconType)i;
        QIcon icon = MacStandardIcon::icon(iconType);
        QListWidgetItem *item = new QListWidgetItem(icon, QString());
        iconListWidget.addItem(item);
    }
    QLabel iconsWidgetLabel("Note: the window is resizable");
    layout->addWidget(&iconListWidget);
    layout->addWidget(&iconsWidgetLabel);

    w.addPreferencesPanel(generalIcon, "General", &blueWidget);
    w.addPreferencesPanel(quickLookIcon, "Icons", &iconsWidget);

    w.show();

    return app.exec();
}
