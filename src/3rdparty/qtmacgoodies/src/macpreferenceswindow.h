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

#ifndef MACPREFERENCESWINDOW_H
#define MACPREFERENCESWINDOW_H

#include <QMainWindow>
#include <QIcon>

class MacPreferencesWindowPrivate;
class MacPreferencesWindow : public QMainWindow
{
    Q_OBJECT
    Q_PROPERTY(int currentPanelIndex READ currentPanelIndex WRITE setCurrentPanelIndex)

public:
    explicit MacPreferencesWindow(QWidget *parent = 0);
    ~MacPreferencesWindow();

    int addPreferencesPanel(const QIcon &icon, const QString &title, QWidget *widget);
    int insertPreferencesPanel(int idx, const QIcon &icon, const QString &title, QWidget *widget);
    void removePreferencesPanel(QWidget *panel);
    int indexForPanel(QWidget *panel);
    int preferencePanelCount();

    QIcon preferencesPanelIcon(int panelIndex) const;
    void setPreferencesPanelIcon(int panelIndex, const QIcon &icon);

    QString preferencesPanelTitle(int panelIndex) const;
    void setPreferencesPanelTitle(int panelIndex, const QString &title);

    int currentPanelIndex() const;
    void setCurrentPanelIndex(int currentPanelIndex);

    virtual QSize sizeHintForPanel(int panelIndex);

signals:
    void activated(int panelIndex);

private slots:
    void toolButtonClicked();

protected:
    bool event(QEvent *event);
    void setVisible(bool visible);

private:
    MacPreferencesWindowPrivate *d;
};

#endif // MACPREFERENCESWINDOW_H
