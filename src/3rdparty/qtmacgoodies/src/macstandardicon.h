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

#ifndef MAC_STANDARD_ICON_H
#define MAC_STANDARD_ICON_H

#include <QIcon>

//
// NOTE: to make use of retina resolution icons don't forget to set application attribute:
// qapp.setAttribute(Qt::AA_UseHighDpiPixmaps);
//
class MacStandardIcon
{
public:
    enum MacStandardIconType{
        QuickLookTemplate,
        BluetoothTemplate,
        IChatTheaterTemplate,
        SlideshowTemplate,
        ActionTemplate,
        SmartBadgeTemplate,
        IconViewTemplate,
        ListViewTemplate,
        ColumnViewTemplate,
        FlowViewTemplate,
        PathTemplate,
        InvalidDataFreestandingTemplate,
        LockLockedTemplate,
        LockUnlockedTemplate,
        GoRightTemplate,
        GoLeftTemplate,
        RightFacingTriangleTemplate,
        LeftFacingTriangleTemplate,
        AddTemplate,
        RemoveTemplate,
        RevealFreestandingTemplate,
        FollowLinkFreestandingTemplate,
        EnterFullScreenTemplate,
        ExitFullScreenTemplate,
        StopProgressTemplate,
        StopProgressFreestandingTemplate,
        RefreshTemplate,
        RefreshFreestandingTemplate,
        Bonjour,
        Computer,
        FolderBurnable,
        FolderSmart,
        Folder,
        Network,
        DotMac, // informally deprecated
        MobileMe,
        MultipleDocuments,
        UserAccounts,
        PreferencesGeneral,
        Advanced,
        Info,
        FontPanel,
        ColorPanel,
        User,
        UserGroup,
        Everyone,
        UserGuest,
        MenuOnStateTemplate,
        MenuMixedStateTemplate,
        ApplicationIcon,
        TrashEmpty,
        TrashFull,
        HomeTemplate,
        BookmarksTemplate,
        Caution,
        StatusAvailable,
        StatusPartiallyAvailable,
        StatusUnavailable,
        StatusNone,
        ShareTemplate,

        LastIcon = ShareTemplate
    };

    static QIcon icon(MacStandardIconType icon, const QSize &size = QSize());
};

#endif // MAC_STANDARD_ICON_H
